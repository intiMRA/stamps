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
        
        let lastIndex: NSDictionary = ["row": card.lastIndex.row.rawValue, "col": card.lastIndex.col]
        
        let row1: NSArray = card.row1.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon] } as NSArray
        
        let row2: NSArray = card.row2.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon] } as NSArray
        
        let row3: NSArray = card.row3.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon] } as NSArray
        
        let row4: NSArray = card.row4.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon] } as NSArray
        
        let row5: NSArray = card.row5.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon] } as NSArray
        
        let cardDict: NSDictionary = [
            "lastIndex": lastIndex,
            "listIndex": card.listIndex,
            "storeId": card.storeId,
            "storeName": card.storeName,
            "row1": row1,
            "row2": row2,
            "row3": row3,
            "row4": row4,
            "row5": row5
        ]
        database.child("users/\(customerModel.userId)/cards/\(card.storeId)").setValue(cardDict)
    }
}
