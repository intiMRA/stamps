//
//  StampsAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 29/05/21.
//

import Foundation
import Combine
import FirebaseDatabase

class StampsAPI {
    let database = Database.database().reference()
    func saveCard(_ card: CardData) {
        guard let customerModel = ReduxStore.shared.customerModel else {
            return
        }
        database.child("users/\(customerModel.userId)/cards/\(card.storeId)").setValue(card)
    }
}
