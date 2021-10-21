//
//  CardCustomizationAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 23/07/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine

struct CardCustomizationError: Error {
    let title: String
    let message: String
    static let savingError = CardCustomizationError(title: "Unable To Save ", message: "Something went wrong while saving your card, please check your internet connection and try again.")
}

protocol CardCustomizationAPIProtocol {
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) -> AnyPublisher<Void, CardCustomizationError>
}

class CardCustomizationAPI: CardCustomizationAPIProtocol {
    
    let database = Database.database().reference()
    
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) -> AnyPublisher<Void, CardCustomizationError> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else {
                    promise(.failure(CardCustomizationError.savingError))
                    return
                }
                let newDetails: NSDictionary = ["numberOfRows": numberOfRows, "numberOfColumns": numberOfColumns, "numberBeforeReward": numberBeforeReward]
                self.database.child("stores/\(storeId)/cardDetails").setValue(newDetails) { error, _ in
                    guard error == nil else {
                        promise(.failure(CardCustomizationError.savingError))
                        return
                    }
                    promise(.success(()))
                }
                
            }
        }
        .eraseToAnyPublisher()
    }
}
