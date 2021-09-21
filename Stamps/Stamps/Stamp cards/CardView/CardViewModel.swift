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
    let api: StampsAPI?
    var store: StoreModel?
    let reduxStore: ReduxStoreProtocol
    let cardCustomizationAPI: CardCustomizationAPI?
    var alertContent: RewardAlertContent?
    var showLinearAnimation = true
    var showSubmitButton: Bool
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var navigateToTabsView = false
    
    @Published var showAlert = false
    @Published var stamps: CardData = CardData(storeName: "", storeId: "", listIndex: -1, numberOfRows: 0, numberOfColums: 0, numberOfStampsBeforeReward: 0)
    
    init(cardData: CardData, api: StampsAPI? = StampsAPI(), showSubmitButton: Bool = false, cardCustomizationAPI: CardCustomizationAPI? = CardCustomizationAPI(), reduxStore: ReduxStoreProtocol = ReduxStore.shared) {
        self.stamps = cardData
        self.api = api
        self.showSubmitButton = showSubmitButton
        self.cardCustomizationAPI = cardCustomizationAPI
        self.reduxStore = reduxStore
    }
    
    func claim(_ index: String) {
        guard let card = stamps.claim(index: index) else {
            return
        }
        
        if card.allSlotsAreClaimed() {
            api?.fetchStoreDetails(code: card.storeId)
                .flatMap(maxPublishers: .max(1), { model -> AnyPublisher<(model: StoreModel?, error: ScanningError?), Never>  in
                    guard let api = self.api else {
                        let error = ScanningError.unableToSave
                        return Just((model: nil, error: error)).eraseToAnyPublisher()
                    }
                    
                    let newCard = CardData.newCard(storeName: card.storeName, storeId: card.storeId, listIndex: card.listIndex, firstIsStamped: false, numberOfRows: model.numberOfRows, numberOfColums: model.numberOfColumns, numberOfStampsBeforeReward: model.numberOfStampsBeforeReward)
                    
                    return api.saveCard(newCard)
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
                .store(in: &cancellables)
        } else {
            api?.saveCard(card)
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
                .store(in: &cancellables)
        }
    }
    
    func loadAlert(card: CardData) {
        alertContent = RewardAlertContent(title: "Reward Redeemed", message: "You redeemed a reward, please show this message to one of the employees of the shop.", handler: {
            if card.allSlotsAreClaimed() {
                guard let numberOfRows = self.store?.numberOfRows,
                      let numberOfColums = self.store?.numberOfColumns,
                      let numberOfStampsBeforeReward = self.store?.numberOfStampsBeforeReward
                else {
                    self.alertContent = RewardAlertContent(title: "Something went wrong", message: "Sorry we couldn't claim your stamp, please ty again.", handler: {
                        self.showAlert = false
                    })
                    return
                }
                self.showLinearAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showLinearAnimation = false
                    self.stamps = CardData.newCard(storeName: card.storeName, storeId: card.storeId, listIndex: card.listIndex, firstIsStamped: false, numberOfRows: numberOfRows, numberOfColums: numberOfColums, numberOfStampsBeforeReward: numberOfStampsBeforeReward)
                    self.reduxStore.changeState(customerModel: self.reduxStore.customerModel?.replaceCard(self.stamps))
                }
                
            } else {
                self.showLinearAnimation = true
                self.stamps = card
                self.reduxStore.changeState(customerModel: self.reduxStore.customerModel?.replaceCard(card))
            }
        })
    }
    
    func submit() {
        cardCustomizationAPI?.uploadNewCardDetails(numberOfRows: stamps.numberOfRows, numberOfColumns: stamps.numberOfColums, numberBeforeReward: stamps.numberOfStampsBeforeReward, storeId: stamps.storeId)
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
                self.alertContent = RewardAlertContent(title: "Updated", message: "Your card details have been updated.", handler: {
                    self.showAlert = false
                    self.navigateToTabsView = true
                })
                self.showAlert = true
            })
            .store(in: &cancellables)
    }
}
