//
//  LogInAPI.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 4/05/21.
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

struct LogInModel {
    let userName: String
}

struct SignUpModel {
    let userName: String
}

class LogInAPI {
    let database = Database.database().reference()
    func login(username: String, password: String, isStore: Bool = false) -> AnyPublisher<LogInModel, Error> {
        Deferred {
            Future { [self] promise in
                Auth.auth().signIn(withEmail: "\(username)@stamps.com", password: password) { result, error in
                    guard let result = result else {
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.failure(NSError()))
                        }
                        return
                    }
                    database.child("users/\(result.user.uid)").observe(DataEventType.value, with: { (snapshot) in
                        let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                        guard let name = postDict["name"] as? String else {
                            promise(.failure(NSError()))
                            return
                        }
                        let stampCards: [CardData] = []
                        ReduxStore.shared.changeState(customerModel: CustomerModel(userId: result.user.uid, username: name, stampCards: stampCards))
                        promise(.success(LogInModel(userName: username)))
                    })
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(username: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, Error> {
        Deferred {
            Future { [self] promise in
                Auth.auth().createUser(withEmail: "\(username)@stamps.com", password: password) { result, error in
                    guard let result = result else {
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.failure(NSError()))
                        }
                        return
                    }
                    if error == nil {
                        if isStore {
                            let dic: NSDictionary = ["name": username]
                            database.child("stores/\(result.user.uid)").setValue(dic)
                            ReduxStore.shared.changeState(storeModel: StoreModel(storeName: username, storeId: result.user.uid))
                        } else {
                            let dic: NSDictionary = ["name": username]
                            database.child("users/\(result.user.uid)").setValue(dic)
                            ReduxStore.shared.changeState(customerModel: CustomerModel(userId: result.user.uid, username: username, stampCards: []))
                        }
                        promise(.success(SignUpModel(userName: username)))
                    } else {
                        promise(.failure(NSError()))
                    }
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
