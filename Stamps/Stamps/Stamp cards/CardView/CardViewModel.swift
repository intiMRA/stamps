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
        
        if store == nil, card.allSlotsAreClaimed() {
            api?.fetchStoreDetails(code: card.storeId)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.alertContent = RewardAlertContent(title: error.title, message: error.message, handler: {
                            self.showAlert = false
                        })
                    }
                }, receiveValue: { model in
                    self.store = model
                    self.loadAlert(card: card)
                    self.showAlert = true
                })
                .store(in: &cancellables)
        } else {
            loadAlert(card: card)
            showAlert = true
        }
    }
    
    func loadAlert(card: CardData) {
        guard let numberOfRows = store?.numberOfrows,
              let numberOfColums = store?.numberOfColumns,
              let numberOfStampsBeforeReward = store?.numberOfStampsBeforeReward
        else {
            alertContent = RewardAlertContent(title: "Something went wrong", message: "Sorry we couldn't claim your stamp, please ty again.", handler: {
                self.showAlert = false
            })
            
            return
        }
        alertContent = RewardAlertContent(title: "Reward Redeemed", message: "You redeemed a reward, please show this message to one of the emplyees of the shop.", handler: {
            if card.allSlotsAreClaimed() {
                self.showLinearAnimation = true
                self.stamps = card
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showLinearAnimation = false
                    self.stamps = CardData.newCard(storeName: card.storeName, storeId: card.storeId, listIndex: card.listIndex, firstIsStamped: false, numberOfRows: numberOfRows, numberOfColums: numberOfColums, numberOfStampsBeforeReward: numberOfStampsBeforeReward)
                    self.reduxStore.changeState(customerModel: self.reduxStore.customerModel?.replaceCard(self.stamps))
                    self.api?.saveCard(self.stamps)
                }
            } else {
                self.showLinearAnimation = true
                self.stamps = card
                self.reduxStore.changeState(customerModel: self.reduxStore.customerModel?.replaceCard(card))
                self.api?.saveCard(card)
            }
        })
    }
    
    func submit() {
        cardCustomizationAPI?.uploadNewCardDetails(numberOfRows: stamps.numberOfRows, numberOfColumns: stamps.numberOfColums, numberBeforeReward: stamps.numberOfStampsBeforeReward, storeId: stamps.storeId)
        
        alertContent = RewardAlertContent(title: "Updated", message: "Your card details have been updated.", handler: {
            self.showAlert = false
            self.navigateToTabsView = true
        })
        self.showAlert = true
    }
}
