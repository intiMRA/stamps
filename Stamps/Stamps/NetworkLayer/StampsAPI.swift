//
//  StampsAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 29/05/21.
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

struct ScanningError: Error {
    let title: String
    let message: String
    static let unableToScan = ScanningError(title: "Invalid Code", message: "The QR code you scanned is not in our database, or a scanning error occurred.")
    
    static let unableToSave = ScanningError(title: "Unable To Save ", message: "Something went wrong while saving your stamp, please check your internet connection and try again.")
}

protocol StampsAPIProtocol {
    func saveCard(_ card: CardData) -> AnyPublisher<Void, ScanningError>
    func fetchStoreDetails(code: String) -> AnyPublisher<StoreModel, ScanningError>
}

class StampsAPI: StampsAPIProtocol {
    
    let database = Database.database().reference()
    func saveCard(_ card: CardData) -> AnyPublisher<Void, ScanningError> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self, let customerModel = ReduxStore.shared.customerModel else {
                    promise(.failure(ScanningError.unableToSave))
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
                    "numberOfColumns": card.numberOfColumns,
                    "stampsAfter": card.numberOfStampsBeforeReward,
                    "card": cardToSave
                ]
                self.database.child("users/\(customerModel.userId)/cards/\(card.storeId)").setValue(cardDict) { error, _ in
                    guard error == nil else {
                        promise(.failure(ScanningError.unableToSave))
                        return
                    }
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchStoreDetails(code: String) -> AnyPublisher<StoreModel, ScanningError> {
        Deferred {
            Future {  [weak self] promise in
                guard let self = self else {
                    promise(.failure(ScanningError.unableToScan))
                    return
                }
                self.database.child("stores/\(code)").observe(DataEventType.value, with: { snapshot in
                    if let storeData = snapshot.value as? [String: AnyObject] {
                        guard
                            let storeName = storeData["name"] as? String,
                            let details = storeData["cardDetails"] as? [String: AnyObject],
                            let numberOfStampsBeforeReward = details["numberBeforeReward"] as? Int,
                            let numberOfColumns = details["numberOfColumns"] as? Int,
                            let numberOfRows = details["numberOfRows"] as? Int
                        else {
                            promise(.failure(ScanningError.unableToScan))
                            return
                        }
                        promise(.success(StoreModel(storeName: storeName, storeId: code, numberOfRows: numberOfRows, numberOfColumns: numberOfColumns, numberOfStampsBeforeReward: numberOfStampsBeforeReward)))
                    } else {
                        promise(.failure(ScanningError.unableToScan))
                    }
                })
            }
        }
        .eraseToAnyPublisher()
    }
}
