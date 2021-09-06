//
//  ScanningViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import Foundation
import Combine

enum ScanningViewModelState: String {
    case startScreen, scanning, showReward, blankScreen
}

class ScanningViewModel: ObservableObject {
    static var invalidCharacters = CharacterSet(charactersIn: ".#$[]")
    var shouldScan: Bool = false
    @Published var state: ScanningViewModelState = .startScreen
    @Published var code: String = ""
    @Published var storeName = ""
    @Published var shouldShowAlert = false
    var error: ScanningError?
    private var cancellables = Set<AnyCancellable>()
    private let cardApi = StampsAPI()
    
    init() {
        //TODO flatmap here
        $code
            .dropFirst()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .flatMap(maxPublishers: .max(1)) { code -> AnyPublisher<(code: String, details: (storeName: String, card: CardData)), ScanningError> in
                return self.mapPublishers(code: code)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .startScreen
                    self.error = error
                    self.shouldShowAlert = true
                }
            }, receiveValue: { tuple in
                self.foundQRCode(tuple.code, details: tuple.details)
            })
            .store(in: &cancellables)
        
        $code
            .sink { code in
                if ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code })?.card.last?.last?.isStamped == true {
                    self.error = ScanningError(title: "Maximum Number Of Stamps", message: "This card has no more slots to be stamped, please claim your rewards")
                    self.shouldShowAlert = true
                }
            }
            .store(in: &cancellables)
    }
    
    func satringState() {
        self.state = .startScreen
        shouldScan = false
    }
    
    func setCode(_ code: String) {
        self.code = code
        self.shouldScan = false
        self.state = .blankScreen
    }
    
    func mapPublishers(code: String) -> AnyPublisher<(code: String, details: (storeName: String, card: CardData)), ScanningError> {
        guard code.rangeOfCharacter(from: ScanningViewModel.invalidCharacters) == nil else {
            let error = ScanningError(title: "Invalid Code", message: "The QR code you scanned is not in our database, or a scanning error occured")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            guard let stampedCard = card.stamp() else {
                let error = ScanningError(title: "Maximum Number Of Stamps", message: "This card has no more slots to be stamped, please claim your rewards")
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return cardApi.saveCard(stampedCard)
                .map { _ in
                    let store = (stampedCard.storeName, stampedCard)
                    return (code, store)
                }
                .eraseToAnyPublisher()
        }
        
        return cardApi.fetchStoreDetails(code: code)
            .flatMap(maxPublishers: .max(1), { store -> AnyPublisher<(StoreModel, CardData), ScanningError> in
                let card = CardData.newCard(storeName: store.storeName, storeId: store.storeId, listIndex: ReduxStore.shared.customerModel?.stampCards.count, numberOfRows: store.numberOfRows, numberOfColums: store.numberOfColumns, numberOfStampsBeforeReward: store.numberOfStampsBeforeReward)
                return self.cardApi.saveCard(card)
                    .map { _ in (store, card)}
                    .eraseToAnyPublisher()
            })
            .map { store, cardData in
                (code, (store.storeName, cardData))
            }
            .eraseToAnyPublisher()
        
    }
    
    func foundQRCode(_ code: String, details: (storeName: String, card: CardData)) {
        guard !code.isEmpty else {
            return
        }
        
        guard code.rangeOfCharacter(from: ScanningViewModel.invalidCharacters) == nil else {
            self.error = ScanningError(title: "Invalid Code", message: "The QR code you scanned is not in our database, or a scanning error occured")
            self.shouldShowAlert = true
            self.state = .startScreen
            return
        }
        self.state = .showReward
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            self.storeName = card.storeName
            ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(details.card))
        } else {
            self.storeName = details.storeName
            ReduxStore.shared.addCard(details.card)
            
        }
    }
}
