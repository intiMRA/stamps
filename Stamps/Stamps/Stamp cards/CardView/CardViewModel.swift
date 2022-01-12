//
//  CardViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine

struct RewardAlertContent {
    let title: String
    let message: String
    let handler: () -> Void
}

class CardViewModel: ObservableObject {
    let api: StampsAPIProtocol
    var store: StoreModel?
    let cardCustomizationAPI: CardCustomizationAPIProtocol
    var alertContent: RewardAlertContent?
    var showLinearAnimation = true
    var showSubmitButton: Bool
    
    var cancellable = Set<AnyCancellable>()
    
    @Published var navigateToTabsView = false
    
    @Published var showAlert = false
    @Published var stamps: CardData = CardData(storeName: "", storeId: "", listIndex: -1, numberOfRows: 0, numberOfColumns: 0, numberOfStampsBeforeReward: 0)
    
    init(cardData: CardData, api: StampsAPIProtocol = StampsAPI(), showSubmitButton: Bool = false, cardCustomizationAPI: CardCustomizationAPIProtocol = CardCustomizationAPI()) {
        self.stamps = cardData
        self.api = api
        self.showSubmitButton = showSubmitButton
        self.cardCustomizationAPI = cardCustomizationAPI
    }
    
    func claim(_ index: String) {
        guard let card = stamps.claim(index: index) else {
            return
        }
        
        if card.allSlotsAreClaimed() {
            api.fetchStoreDetails(code: card.storeId)
                .flatMap(maxPublishers: .max(1), { model -> AnyPublisher<(model: StoreModel?, error: ScanningError?), Never>  in
                    let newCard = CardData.newCard(storeName: card.storeName, storeId: card.storeId, listIndex: card.listIndex, firstIsStamped: false, numberOfRows: model.numberOfRows, numberOfColumns: model.numberOfColumns, numberOfStampsBeforeReward: model.numberOfStampsBeforeReward)
                    
                    return self.api.saveCard(newCard)
                        .map { _ in (model: model, error: nil) }
                        .catch({ error in
                            Just((model: nil, error: error)).eraseToAnyPublisher()
                        })
                                .eraseToAnyPublisher()
                })
                .catch({ error in
                    Just((model: nil, error: error)).eraseToAnyPublisher()
                })
                        .receive(on: DispatchQueue.main)
                        .sink(receiveValue: { tuple in
                            guard tuple.error == nil, let model = tuple.model else {
                                if let error = tuple.error {
                                    self.alertContent = RewardAlertContent(title: error.title, message: error.message, handler: {
                                        self.showAlert = false
                                    })
                                } else {
                                    let error = ScanningError.unableToSave
                                    self.alertContent = RewardAlertContent(title: error.title, message: error.message, handler: {
                                        self.showAlert = false
                                    })
                                }
                                return
                            }
                            
                            self.store = model
                            self.loadAlert(card: card)
                            self.showAlert = true
                        })
                        .store(in: &cancellable)
        } else {
            api.saveCard(card)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.alertContent = RewardAlertContent(title: error.title, message: error.message, handler: {
                            self.showAlert = false
                        })
                    }
                }, receiveValue: { _ in
                    self.loadAlert(card: card)
                    self.showAlert = true
                })
                .store(in: &cancellable)
        }
    }
    
    func loadAlert(card: CardData) {
        alertContent = RewardAlertContent(title: "RewardRedeemedTitle".localized, message: "RewardRedeemedMessage".localized, handler: {
            if card.allSlotsAreClaimed() {
                guard let numberOfRows = self.store?.numberOfRows,
                      let numberOfColumns = self.store?.numberOfColumns,
                      let numberOfStampsBeforeReward = self.store?.numberOfStampsBeforeReward
                else {
                    self.alertContent = RewardAlertContent(title: "UnkownErrorTitle".localized, message: "UnkownErrorMessage".localized, handler: {
                        self.showAlert = false
                    })
                    return
                }
                self.showLinearAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Task.init {
                        self.showLinearAnimation = false
                        let cardData = CardData.newCard(storeName: card.storeName, storeId: card.storeId, listIndex: card.listIndex, firstIsStamped: false, numberOfRows: numberOfRows, numberOfColumns: numberOfColumns, numberOfStampsBeforeReward: numberOfStampsBeforeReward)
                        await ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(cardData))
                        self.stamps = cardData
                    }
                }
                
            } else {
                Task.init {
                    self.showLinearAnimation = true
                    await ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(card))
                    DispatchQueue.main.async {
                        self.stamps = card
                    }
                }
            }
        })
    }
    
    func submit() {
        cardCustomizationAPI.uploadNewCardDetails(numberOfRows: stamps.numberOfRows, numberOfColumns: stamps.numberOfColumns, numberBeforeReward: stamps.numberOfStampsBeforeReward, storeId: stamps.storeId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    guard let self = self else {
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.showAlert = true
                        self.alertContent = RewardAlertContent(title: error.title, message: error.message, handler: {
                            self.showAlert = false
                        })
                    }
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.alertContent = RewardAlertContent(title: "Updated".localized, message: "CardDetailsUpdated".localized, handler: {
                    self.showAlert = false
                    self.navigateToTabsView = true
                })
                self.showAlert = true
            })
            .store(in: &cancellable)
    }
}
