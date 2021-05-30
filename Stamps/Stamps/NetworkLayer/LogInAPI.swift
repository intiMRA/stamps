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
    let name: String
    let id: String
}

func cards(from dict: [String: AnyObject]) -> [CardData] {
    var cards = [CardData]()
    
    guard let cardsDictionary = dict["cards"] as? [String: AnyObject] else {
        return []
    }
    
    cardsDictionary.forEach({ key, value in
        guard
            let value = value as? [String: AnyObject],
            let storeName = value["storeName"] as? String,
            let storeId = value["storeId"] as? String,
            let listIndex = value["listIndex"] as? Int,
            let lastIndex = value["lastIndex"] as? [String: AnyObject],
            let row = lastIndex["row"] as? String,
            let col = lastIndex["col"] as? Int,
            let rowIndex = RowIndex(rawValue: row)
        else {
            return
        }
        
        cards.append(CardData(row1: cardSlot(from: value, row: "row1"), row2: cardSlot(from: value, row: "row2"), row3: cardSlot(from: value, row: "row3"), row4: cardSlot(from: value, row: "row4"), row5: cardSlot(from: value, row: "row5"), storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: rowIndex, col: col)))
    })
    return cards
}

func cardSlot(from dict: [String: AnyObject], row: String) -> [CardSlot] {
    guard let rowData = dict[row] as? [[String: AnyObject]]  else {
        return []
    }
    
    return rowData.compactMap { value in
        guard
            let isStamped = value["isStamped"] as? Bool,
            let index = value["index"] as? String,
            let hasIcon = value["hasIcon"] as? Bool
        else {
            return nil
        }
        return CardSlot(isStamped: isStamped, index: index, hasIcon: hasIcon)
    }
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
                    
                    if isStore {
                        promise(.success(LogInModel(userName: username)))
                    } else {
                        database.child("users/\(result.user.uid)").observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            guard let name = postDict["name"] as? String else {
                                promise(.failure(NSError()))
                                return
                            }
                            let stampCards: [CardData] = cards(from: postDict)
                            ReduxStore.shared.changeState(customerModel: CustomerModel(userId: result.user.uid, username: name, stampCards: stampCards))
                            promise(.success(LogInModel(userName: username)))
                        })
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(username: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, Error> {
        Deferred {
            Future { [self] promise in
                Auth.auth().createUser(withEmail: "\(username.replacingOccurrences(of: " ", with: "-"))@stamps.com", password: password) { result, error in
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
                        promise(.success(SignUpModel(name: username, id: result.user.uid)))
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
