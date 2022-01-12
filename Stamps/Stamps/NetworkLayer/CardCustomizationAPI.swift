//
//  CardCustomizationAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 23/07/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

struct CardCustomizationError: Error {
    let title: String
    let message: String
    static let savingError = CardCustomizationError(title: "UnableToSaveErrorTitle".localized, message: "UnableToSaveErrorMessage".localized)
}

protocol CardCustomizationAPIProtocol {
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) -> AnyPublisher<Void, CardCustomizationError>
}

class CardCustomizationAPI: CardCustomizationAPIProtocol {
    
    let store = Firestore.firestore()
    
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) -> AnyPublisher<Void, CardCustomizationError> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else {
                    promise(.failure(CardCustomizationError.savingError))
                    return
                }
                let newDetails: NSDictionary = ["numberOfRows": numberOfRows, "numberOfColumns": numberOfColumns, "numberBeforeReward": numberBeforeReward]
                self.store.collection("stores").document(storeId).setValue(newDetails, forKey: "cardDetails")
                promise(.success(()))
                
            }
        }
        .eraseToAnyPublisher()
    }
}
