//
//  CardCustomizationAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 23/07/21.
//

import Foundation
import FirebaseDatabase

protocol CardCustomizationAPIProtocol {
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String)
}

class CardCustomizationAPI: CardCustomizationAPIProtocol {
    let database = Database.database().reference()
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) {
        let newDetails: NSDictionary = ["numberOfRows": numberOfRows, "numberOfColumns": numberOfColumns, "numberBeforeReward": numberBeforeReward]
        database.child("stores/\(storeId)/cardDetails").setValue(newDetails)
    }
}
