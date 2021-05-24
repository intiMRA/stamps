//
//  LogInAPI.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 4/05/21.
//

import Foundation
import Combine
import FirebaseDatabase

struct LogInModel {
    let userName: String
}

struct SignUpModel {
    let userName: String
}

class LogInAPI {
    let database = Database.database().reference()
    func login(username: String, password: String) -> AnyPublisher<LogInModel, Error> {
        Deferred {
            Future { [self] promise in
                guard let s = try? encryptMessage(message: username, encryptionKey: password), let ss = try? decryptMessage(encryptedMessage: s, encryptionKey: password) else {
                    promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                    return
                }
                if ss == username {
                    let row1 = [CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_0"),
                                CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_1"),
                                CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_2"),
                                CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_3", hasIcon: true)]
                    
                    let row2 = [CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_0"),
                                CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_1"),
                                CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_2"),
                                CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_3", hasIcon: true)]
                    
                    let row3 = [CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_0"),
                                CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_1"),
                                CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_2"),
                                CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_3", hasIcon: true)]
                    
                    let row4 = [CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_0"),
                                CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_1"),
                                CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_2"),
                                CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_3", hasIcon: true)]
                    
                    let row5 = [CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_0"),
                                CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_1"),
                                CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_2"),
                                CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_3", hasIcon: true)]
                    
                    ReduxStore.shared.customerModel = customerModel(username: username, stores: [Store()], stampCards: ["The Store": CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5)])
                    promise(.success(LogInModel(userName: ss)))
                } else {
                    promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(username: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, Error> {
        Deferred {
            Future { [self] promise in
                guard let s = try? encryptMessage(message: username, encryptionKey: password), let ss = try? decryptMessage(encryptedMessage: s, encryptionKey: password) else {
                    promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                    return
                }
                if ss == username {
                    if isStore {
                        ReduxStore.shared.storeModel = Store()
                    } else {
                        
                        ReduxStore.shared.customerModel = customerModel(username: username)
                    }
                    promise(.success(SignUpModel(userName: ss)))
                } else {
                    promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
}
