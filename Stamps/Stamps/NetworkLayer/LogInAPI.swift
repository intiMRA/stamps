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
    func login(username: String, password: String, isStore: Bool = false) -> AnyPublisher<LogInModel, Error> {
        Deferred {
            Future { [self] promise in
                guard let s = try? encryptMessage(message: username, encryptionKey: password), let ss = try? decryptMessage(encryptedMessage: s, encryptionKey: password) else {
                    promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                    return
                }
                database.child("users").observeSingleEvent(of: .value, with: { (snapshot) in

                       if snapshot.hasChild(username){
                        _ = database.child("users").child(username).observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            let name = postDict["name"] as! String
                            let stores: [Store] = []
                            let stampCards: [String: CardData] = [:]
                            ReduxStore.shared.customerModel = customerModel(username: name, stores: stores, stampCards: stampCards)
                            promise(.success(LogInModel(userName: ss)))
                        })

                       }else{
                        promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                       }
                   })
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
                        let dic: NSDictionary = ["name": username]
                        database.child("stores/\(username)").setValue(dic)
                        ReduxStore.shared.storeModel = Store()
                    } else {
                        let dic: NSDictionary = ["name": username]
                        database.child("users/\(username)").setValue(dic)
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
