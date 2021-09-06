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
        $code
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .flatMap(maxPublishers: .max(1)) { code in
                return self.mapPublishers(code: code)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { tuple in
                guard tuple.error == nil else {
                    self.state = .startScreen
                    self.error = tuple.error
                    self.shouldShowAlert = true
                    return
                }
                
                guard let code = tuple.code, let details = tuple.details else {
                    return
                }
                
                self.foundQRCode(code, details: details)
            })
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
    
    func mapPublishers(code: String) -> AnyPublisher<(code: String?, details: (storeName: String, card: CardData)?, error: ScanningError?), Never> {
        guard code.rangeOfCharacter(from: ScanningViewModel.invalidCharacters) == nil else {
            let error = ScanningError(title: "Invalid Code", message: "The QR code you scanned is not in our database, or a scanning error occured")
            return Just((code: nil, details: nil, error: error)).eraseToAnyPublisher()
        }
        
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            guard let stampedCard = card.stamp() else {
                let error = ScanningError(title: "Maximum Number Of Stamps", message: "This card has no more slots to be stamped, please claim your rewards")
                return Just((code: nil, details: nil, error: error)).eraseToAnyPublisher()
            }
            
            return cardApi.saveCard(stampedCard)
                .map { _ in
                    let store = (stampedCard.storeName, stampedCard)
                    return (code, store, nil)
                }
                .catch({ error in
                    return Just((code: nil, details: nil, error: error)).eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
        }
        
        return cardApi.fetchStoreDetails(code: code)
            .flatMap(maxPublishers: .max(1), { store -> AnyPublisher<(data: (store: StoreModel, card: CardData)?, error: ScanningError?), Never> in
                let card = CardData.newCard(storeName: store.storeName, storeId: store.storeId, listIndex: ReduxStore.shared.customerModel?.stampCards.count, numberOfRows: store.numberOfRows, numberOfColums: store.numberOfColumns, numberOfStampsBeforeReward: store.numberOfStampsBeforeReward)
                return self.cardApi.saveCard(card)
                    .map { _ in (data: (store: store, card: card), error: nil)}
                    .catch({ error in
                        Just((data: nil, error: error)).eraseToAnyPublisher()
                    })
                    .eraseToAnyPublisher()
            })
            .map { details, error in
                guard error == nil, let details = details else {
                    return (nil, nil, error)
                }
                
                return (code: code, details: (storeName: details.store.storeName, card: details.card), error: error)
            }
            .catch({ error in
                return Just((code: nil, details: nil, error: error)).eraseToAnyPublisher()
            })
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
