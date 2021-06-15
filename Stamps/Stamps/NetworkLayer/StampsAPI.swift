//
//  StampsAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 29/05/21.
//

import Foundation
import Combine
import FirebaseDatabase

struct ScanningError: Error {
    let title: String
    let message: String
}

class StampsAPI {
    static let scanningError = ScanningError(title: "Invalid Code", message: "The QR code you scanned is not in our database, or a scanning error occured")
    
    let database = Database.database().reference()
    func saveCard(_ card: CardData) {
        guard let customerModel = ReduxStore.shared.customerModel else {
            return
        }
        
        let lastIndex: NSDictionary = ["row": card.lastIndex.row.rawValue, "col": card.lastIndex.col]
        
        let row1: NSArray = card.row1.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } as NSArray
        
        let row2: NSArray = card.row2.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } as NSArray
        
        let row3: NSArray = card.row3.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } as NSArray
        
        let row4: NSArray = card.row4.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } as NSArray
        
        let row5: NSArray = card.row5.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } as NSArray
        
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
    
    func fetchStoreDetails(code: String) -> AnyPublisher<StoreModel, ScanningError> {
        Deferred {
            Future { promise in
                self.database.child("stores/\(code)").observe(DataEventType.value, with: { snapshot in
                    if let storeData = snapshot.value as? [String: AnyObject] {
                        guard
                            let storeName = storeData["name"] as? String
                        else {
                            promise(.failure(StampsAPI.scanningError))
                            return
                        }
                        promise(.success(StoreModel(storeName: storeName, storeId: code)))
                    } else {
                        promise(.failure(StampsAPI.scanningError))
                    }
                })
            }
        }
        .eraseToAnyPublisher()
    }
}
