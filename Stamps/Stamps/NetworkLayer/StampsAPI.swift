//
//  StampsAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 29/05/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

struct ScanningError: Error {
    let title: String
    let message: String
    static let unableToScan = ScanningError(title: "InvalidCode".localized, message: "QRCodeNotFound".localized)
    
    static let unableToSave = ScanningError(title: "UnableToSaveTitle".localized, message: "UnableToSaveMessage".localized)
}

protocol StampsAPIProtocol {
    func saveCard(_ card: CardData) -> AnyPublisher<Void, ScanningError>
    func fetchStoreDetails(code: String) -> AnyPublisher<StoreModel, ScanningError>
}

class StampsAPI: StampsAPIProtocol {
    
    let store = Firestore.firestore()
    func saveCard(_ card: CardData) -> AnyPublisher<Void, ScanningError> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self, let customerModel = ReduxStore.shared.customerModel else {
                    promise(.failure(ScanningError.unableToSave))
                    return
                }
                
                let nextToStamp: NSDictionary = ["row": card.nextToStamp.row, "col": card.nextToStamp.col]
                
                let cardToSave: NSArray = card.card.map { $0.map { ["isStamped": $0.isStamped, "index": $0.index, "hasIcon": $0.hasIcon, "claimed": $0.claimed] } } as NSArray
                
                var cardToSaveDict = [String: AnyObject]()
                
                for i in 0..<cardToSave.count {
                    cardToSaveDict["\(i)"] = cardToSave[i] as AnyObject
                }
                
                let cardDict: [String: Any] = [
                    "nextToStamp": nextToStamp,
                    "listIndex": card.listIndex,
                    "storeId": card.storeId,
                    "storeName": card.storeName,
                    "numberOfRows": card.numberOfRows,
                    "numberOfColumns": card.numberOfColumns,
                    "stampsAfter": card.numberOfStampsBeforeReward,
                    "card": cardToSaveDict
                ]
                self.store.collection("users").document(customerModel.userId).setData(["cards": [card.storeId: cardDict]], merge: true) { error in
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
                self.store.collection("stores").document(code).getDocument { snapshot, error in
                    if let storeData = snapshot {
                        guard
                            storeData.exists == true,
                            let storeData = storeData.data(),
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
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
