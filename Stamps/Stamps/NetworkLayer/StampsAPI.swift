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
        
        let nextToStamp: NSDictionary = ["row": card.nextToStamp.row, "col": card.nextToStamp.col]
        
        let cardToSave: NSArray = card.card.map { $0.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } } as NSArray
        
        let cardDict: NSDictionary = [
            "nextToStamp": nextToStamp,
            "listIndex": card.listIndex,
            "storeId": card.storeId,
            "storeName": card.storeName,
            "numberOfRows": card.numberOfRows,
            "numberOfColums": card.numberOfColums,
            "stampsAfter": card.stampsAfter,
            "card": cardToSave
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
