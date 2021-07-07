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
    let isStore: Bool
}

struct LogInError: Error {
    static let unkownError = LogInError(title: "Something went wrong", message: "An unknown error occured, please try again later.")
    let title: String
    let message: String
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
    cardsDictionary.forEach { (key: String, value: AnyObject) in
        
    }
    cardsDictionary.forEach({ key, value in
        guard
            let value = value as? [String: AnyObject],
            let storeName = value["storeName"] as? String,
            let storeId = value["storeId"] as? String,
            let listIndex = value["listIndex"] as? Int,
            let lastIndex = value["nextToStamp"] as? [String: AnyObject],
            let rowIndex = lastIndex["row"] as? Int,
            let col = lastIndex["col"] as? Int,
            let numberOfRows = value["numberOfRows"] as? Int,
            let numberOfColums = value["numberOfColums"] as? Int,
            let stampsAfter = value["stampsAfter"] as? Int,
            let cardDictionary = value["card"] as? [[[String: AnyObject]]]
        else {
            return
        }
        
        var cardsSlots = [[CardSlot]]()
        
        cardDictionary.forEach { data in
            cardsSlots.append(cardSlot(from: value, rowData: data))
        }
        
        cards.append(CardData(card: cardsSlots, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: rowIndex, col: col), numberOfRows: numberOfRows, numberOfColums: numberOfColums, stampsAfter: stampsAfter))
    })
    return cards
}

func cardSlot(from dict: [String: AnyObject], rowData: [[String: AnyObject]]) -> [CardSlot] {

    return rowData.compactMap { value in
        guard
            let isStamped = value["isStamped"] as? Bool,
            let index = value["index"] as? String,
            let hasIcon = value["hasIcon"] as? Bool,
            let claimed = value["claimed"] as? Bool
        else {
            return nil
        }
        return CardSlot(isStamped: isStamped, index: index, hasIcon: hasIcon, claimed: claimed)
    }
}


class LogInAPI {
    let database = Database.database().reference()
    
    func logInError(from errorCode: AuthErrorCode) -> LogInError {
        switch errorCode {
        case .invalidCredential:
            return LogInError(title: "Wrong Credentials", message: "Please enter a valid username and password.")
        case .emailAlreadyInUse:
            return LogInError(title: "Invalid Username", message: "Please enter another username this one is already in use.")
        case .invalidEmail:
            return LogInError(title: "Invalid Username", message: "This username is invalid, please choose a different one.")
        case .wrongPassword:
            return LogInError(title: "Invalid Password", message: "Plese enter your correct password.")
        case .userNotFound:
            return LogInError(title: "Invalid Username", message: "There is no user with that name in our database, please enter a correct username.")
        case .accountExistsWithDifferentCredential:
            return LogInError(title: "Invalid Credentials", message: "Please enter a correct username and password.")
        case .networkError:
            return LogInError(title: "Network Error", message: "Please make sure you have an internet connection to use the app.")
        case .credentialAlreadyInUse:
            return LogInError(title: "Invalid Credentials", message: "Please enter your correct username and password.")
        case .weakPassword:
            return LogInError(title: "Invalid Password", message: "Passwords need to contain at least 1 number and need to be at least 6 characters long.")
        case .webNetworkRequestFailed:
            return LogInError(title: "Network Error", message: "Please make sure you have an internet connection to use the app.")
        default:
            return LogInError.unkownError
        }
    }
    
    func login(username: String, password: String, isStore: Bool = false) -> AnyPublisher<LogInModel, LogInError> {
        Deferred {
            Future { [self] promise in
                let nameSuffix = isStore ? "@stampsStore.com" : "@stamps.com"
                Auth.auth().signIn(withEmail: "\(username)\(nameSuffix)", password: password) { result, error in
                    guard let result = result else {
                        if let error = error {
                            if let errorCode = AuthErrorCode(rawValue: error._code) {
                                promise(.failure(logInError(from: errorCode)))
                            }
                            promise(.failure(LogInError.unkownError))
                        } else {
                            promise(.failure(LogInError.unkownError))
                        }
                        return
                    }
                    
                    if isStore {
                        ReduxStore.shared.changeState(storeModel: StoreModel(storeName: username, storeId: result.user.uid))
                        promise(.success(LogInModel(userName: username, isStore: true)))
                    } else {
                        database.child("users/\(result.user.uid)").observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            guard let name = postDict["name"] as? String else {
                                promise(.failure(LogInError.unkownError))
                                return
                            }
                            let stampCards: [CardData] = cards(from: postDict)
                            ReduxStore.shared.changeState(customerModel: CustomerModel(userId: result.user.uid, username: name, stampCards: stampCards))
                            promise(.success(LogInModel(userName: username, isStore: false)))
                        })
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logInUserAlreadySignedIn() -> AnyPublisher<LogInModel, LogInError> {
        Deferred {
            Future { [self] promise in
                guard let currentUser = Auth.auth().currentUser else {
                    promise(.failure(LogInError.unkownError))
                    return
                }
                
                let splitUserEmail = currentUser.email?.split(separator: "@")
                guard let subString = splitUserEmail?[0] else {
                    promise(.failure(LogInError.unkownError))
                    return
                }
                let username = String(subString)
                
                let isStore = splitUserEmail?[1] == "stampsstore.com"
                guard ReduxStore.shared.customerModel == nil else {
                    if isStore {
                        promise(.success(LogInModel(userName: currentUser.uid, isStore: true)))
                    } else {
                        promise(.success(LogInModel(userName: username, isStore: false)))
                    }
                    return
                }
                
                if isStore {
                    ReduxStore.shared.changeState(storeModel: StoreModel(storeName: username, storeId: currentUser.uid))
                    promise(.success(LogInModel(userName: currentUser.uid, isStore: true)))
                } else {
                    database.child("users/\(currentUser.uid)").observe(DataEventType.value, with: { (snapshot) in
                        let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                        guard let name = postDict["name"] as? String else {
                            promise(.failure(LogInError.unkownError))
                            return
                        }
                        let stampCards: [CardData] = cards(from: postDict)
                        if ReduxStore.shared.customerModel == nil {
                            ReduxStore.shared.changeState(customerModel: CustomerModel(userId: currentUser.uid, username: name, stampCards: stampCards))
                        }
                        promise(.success(LogInModel(userName: username, isStore: false)))
                    })
                }
        }
    }.eraseToAnyPublisher()
    }
    
    func signUp(username: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, LogInError> {
        Deferred {
            Future { [self] promise in
                let nameSuffix = isStore ? "@stampsStore.com" : "@stamps.com"
                Auth.auth().createUser(withEmail: "\(username.replacingOccurrences(of: " ", with: "-"))\(nameSuffix)", password: password) { result, error in
                    guard let result = result else {
                        if let error = error {
                            if let errorCode = AuthErrorCode(rawValue: error._code) {
                                promise(.failure(logInError(from: errorCode)))
                            }
                            promise(.failure(LogInError.unkownError))
                        } else {
                            promise(.failure(LogInError.unkownError))
                        }
                        return
                    }
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
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
