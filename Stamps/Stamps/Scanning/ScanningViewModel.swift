//
//  ScanningViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import Foundation
import Combine

enum ScanningViewModelState: String {
    case showStartState, scanning, showReward, blankScreen, showStampAnimation, showRewardAnimation
}

enum FoundQRCodeStates {
    case hasCard(card: CardData), doesNotHaveCard, none
}

class ScanningViewModel: ObservableObject {
    static var invalidCharacters = CharacterSet(charactersIn: ".#$[]")
    var shouldScan: Bool = false
    @Published var state: ScanningViewModelState = .showStartState
    @Published var code: String = ""
    @Published var storeName = ""
    @Published var shouldShowAlert = false
    var error: ScanningError?
    private var cancellable = Set<AnyCancellable>()
    private let cardApi: StampsAPIProtocol
    
    init(cardApi: StampsAPIProtocol = StampsAPI()) {
        self.cardApi = cardApi
        $code
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .flatMap(maxPublishers: .max(1)) { code in
                return self.mapPublishers(code: code)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { tuple in
                guard tuple.error == nil else {
                    self.state = .showStartState
                    self.error = tuple.error
                    self.shouldShowAlert = true
                    return
                }
                
                guard let code = tuple.code, let details = tuple.details else {
                    return
                }
                Task.init {
                    let returnedDetails = await self.foundQRCode(code, details: details)
                    DispatchQueue.main.async {
                        switch returnedDetails {
                        case let .hasCard(card: card):
                            self.storeName = card.storeName
                            self.state = card.isRewardStamp() ? .showRewardAnimation : .showStampAnimation
                        case .doesNotHaveCard:
                            self.storeName = details.storeName
                            self.state = .showStampAnimation
                        case .none:
                            break
                        }
                    }
                }
            })
            .store(in: &cancellable)
    }
    
    func startingState() {
        self.state = .showStartState
        shouldScan = false
    }
    
    func setCode(_ code: String) {
        self.code = code
        self.shouldScan = false
        self.state = .blankScreen
    }
    
    func mapPublishers(code: String) -> AnyPublisher<(code: String?, details: (storeName: String, card: CardData)?, error: ScanningError?), Never> {
        guard code.rangeOfCharacter(from: ScanningViewModel.invalidCharacters) == nil else {
            let error = ScanningError(title: "InvalidCode".localized, message: "QRCodeError".localized)
            return Just((code: nil, details: nil, error: error)).eraseToAnyPublisher()
        }
        
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            guard let stampedCard = card.stamp() else {
                let error = ScanningError(title: "MaximumNumberOfStamps".localized, message: "NoMoreSlots".localized)
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
                let card = CardData.newCard(storeName: store.storeName, storeId: store.storeId, listIndex: ReduxStore.shared.customerModel?.stampCards.count, numberOfRows: store.numberOfRows, numberOfColumns: store.numberOfColumns, numberOfStampsBeforeReward: store.numberOfStampsBeforeReward)
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
    
    func foundQRCode(_ code: String, details: (storeName: String, card: CardData)) async ->  FoundQRCodeStates {
        guard !code.isEmpty else {
            return .none
        }
        
        guard code.rangeOfCharacter(from: ScanningViewModel.invalidCharacters) == nil else {
            self.error = ScanningError(title: "InvalidCode".localized, message: "QRCodeError".localized)
            self.shouldShowAlert = true
            self.state = .showStartState
            return .none
        }
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            await ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(details.card))
            return .hasCard(card: card)
        } else {
            await ReduxStore.shared.addCard(details.card)
            return .doesNotHaveCard
            
        }
    }
}
