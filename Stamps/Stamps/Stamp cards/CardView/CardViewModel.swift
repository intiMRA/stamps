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
}

class CardViewModel: ObservableObject {
    let api = StampsAPI()
    var alertContent: RewardAlertContent?
    @Published var showAlert = false
    @Published var stamps: CardData = CardData(storeName: "", storeId: "", listIndex: -1)
    
    init(cardData: CardData) {
        self.stamps = cardData
    }
    
    func claim(_ index: String) {
        guard let card = stamps.claim(index: index) else {
            return
        }
        
        ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(card))
        api.saveCard(card)
        alertContent = RewardAlertContent(title: "Reward Redeemed", message: "You redeemed a reward, please show this message to one of the emplyees of the shop.")
        showAlert = true
        stamps = card
    }
}
