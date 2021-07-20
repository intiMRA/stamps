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
    var alertContent: RewardAlertContent?
    var showLinearAnimation = true
    @Published var showAlert = false
    @Published var stamps: CardData = CardData(storeName: "", storeId: "", listIndex: -1)
    
    init(cardData: CardData, api: StampsAPI? = StampsAPI()) {
        self.stamps = cardData
        self.api = api
    }
    
    func claim(_ index: String) {
        guard let card = stamps.claim(index: index) else {
            return
        }
        
        alertContent = RewardAlertContent(title: "Reward Redeemed", message: "You redeemed a reward, please show this message to one of the emplyees of the shop.", handler: {
            if card.allSlotsAreClaimed() {
                self.showLinearAnimation = true
                self.stamps = card
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showLinearAnimation = false
                    self.stamps = CardData.newCard(storeName: card.storeName, storeId: card.storeId, listIndex: card.listIndex, firstIsStamped: false)
                    ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(self.stamps))
                    self.api?.saveCard(self.stamps)
                }
            } else {
                self.showLinearAnimation = true
                self.stamps = card
                ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(card))
                self.api?.saveCard(card)
            }
        })
        showAlert = true
    }
}
