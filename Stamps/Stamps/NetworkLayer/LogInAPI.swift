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

protocol LogInAPIProtocol: AnyObject {
    func login(email: String, password: String, isStore: Bool) -> AnyPublisher<LogInModel, LogInError>
    func logInUserAlreadySignedIn() -> AnyPublisher<LogInModel, LogInError>
    func signUp(email: String, userName: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, LogInError>
}

struct LogInModel {
    let id: String
    let userName: String
    let email: String
    let isStore: Bool
}

struct LogInError: Error {
    static let unkownError = LogInError(title: "UnkownErrorTtitle".localized, message: "UnkownErrorMessage".localized)
    let title: String
    let message: String
}

struct SignUpModel {
    let userName: String
    let email: String
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
            let lastIndex = value["nextToStamp"] as? [String: AnyObject],
            let rowIndex = lastIndex["row"] as? Int,
            let col = lastIndex["col"] as? Int,
            let numberOfRows = value["numberOfRows"] as? Int,
            let numberOfColumns = value["numberOfColumns"] as? Int,
            let stampsAfter = value["stampsAfter"] as? Int,
            let cardDictionary = value["card"] as? [[[String: AnyObject]]]
        else {
            return
        }
        
        var cardsSlots = [[CardSlot]]()
        
        cardDictionary.forEach { data in
            cardsSlots.append(cardSlot(from: value, rowData: data))
        }
        
        cards.append(CardData(card: cardsSlots, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: rowIndex, col: col), numberOfRows: numberOfRows, numberOfColumns: numberOfColumns, numberOfStampsBeforeReward: stampsAfter))
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


class LogInAPI: LogInAPIProtocol {
    let database = Database.database().reference()
    
    static func logInError(from errorCode: AuthErrorCode) -> LogInError {
        switch errorCode {
        case .invalidCredential:
            return LogInError(title: "WrongCredentialsErrorTitle".localized, message: "WrongCredentialsErrorMessage".localized)
        case .emailAlreadyInUse:
            return LogInError(title: "InvalidEmail".localized, message: "CredentialAlreadyInUse".localized)
        case .invalidEmail:
            return LogInError(title: "InvalidEmail".localized, message: "InvalidEmailError".localized)
        case .wrongPassword:
            return LogInError(title: "InvalidPassword".localized, message: "InvalidPasswordError".localized)
        case .userNotFound:
            return LogInError(title: "InvalidEmail".localized, message: "NoSuchEmailError".localized)
        case .accountExistsWithDifferentCredential:
            return LogInError(title: "InvalidCredentials".localized, message: "AccountExistsWithDifferentCredential".localized)
        case .networkError:
            return LogInError(title: "NetworkErrorTitle".localized, message: "NetworkErrorMessage".localized)
        case .credentialAlreadyInUse:
            return LogInError(title: "InvalidCredentials".localized, message: "CredentialAlreadyInUse".localized)
        case .weakPassword:
            return LogInError(title: "InvalidPassword".localized, message: "WeakPassword".localized)
        case .webNetworkRequestFailed:
            return LogInError(title: "NetworkErrorTitle".localized, message: "NetworkErrorMessage".localized)
        default:
            return LogInError.unkownError
        }
    }
    
    func login(email: String, password: String, isStore: Bool = false) -> AnyPublisher<LogInModel, LogInError> {
        Deferred {
            Future { [weak self] promise in
                let splitEmail = email.split(separator: "@")
                guard let self = self,
                      let part1 = splitEmail[safe: 0],
                      let part2 = splitEmail[safe: 1]
                else {
                    promise(.failure(LogInError.unkownError))
                    return
                }
                
                let emailWithSuffix = isStore ? "\(part1)_Store@\(part2)" : email
                Auth.auth().signIn(withEmail: emailWithSuffix, password: password) { result, error in
                    guard let result = result else {
                        if let error = error {
                            if let errorCode = AuthErrorCode(rawValue: error._code) {
                                promise(.failure(LogInAPI.logInError(from: errorCode)))
                            }
                            promise(.failure(LogInError.unkownError))
                        } else {
                            promise(.failure(LogInError.unkownError))
                        }
                        return
                    }
                    
                    if isStore {
                        self.database.child("stores/\(result.user.uid)").observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            guard let name = postDict["name"] as? String,
                                  let details = postDict["cardDetails"] as? [String: AnyObject],
                                  let numberOfStampsBeforeReward = details["numberBeforeReward"] as? Int,
                                  let numberOfColumns = details["numberOfColumns"] as? Int,
                                  let numberOfRows = details["numberOfRows"] as? Int
                            else {
                                promise(.failure(LogInError.unkownError))
                                return
                            }
                            ReduxStore.shared.changeState(storeModel:
                                                            StoreModel(storeName: name,
                                                                       storeId: result.user.uid,
                                                                       numberOfRows: numberOfRows,
                                                                       numberOfColumns: numberOfColumns,
                                                                       numberOfStampsBeforeReward: numberOfStampsBeforeReward))
                            promise(.success(LogInModel(id: result.user.uid, userName: name, email: email, isStore: true)))
                        })
                    } else {
                        self.database.child("users/\(result.user.uid)").observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            guard let email = postDict["email"] as? String,
                                  let name = postDict["name"] as? String
                            else {
                                promise(.failure(LogInError.unkownError))
                                return
                            }
                            let stampCards: [CardData] = cards(from: postDict)
                            ReduxStore.shared.changeState(customerModel: CustomerModel(userId: result.user.uid, email: email, userName: name, stampCards: stampCards))
                            promise(.success(LogInModel(id: result.user.uid, userName: name, email: email, isStore: false)))
                        })
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func reloadUser() async throws {
        try await Auth.auth().currentUser?.reload()
    }
    
    func logInUserAlreadySignedIn() -> AnyPublisher<LogInModel, LogInError> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self, let currentUser = Auth.auth().currentUser else {
                    promise(.failure(LogInError.unkownError))
                    return
                }
                
                Task.init {
                    do {
                        try await self.reloadUser()
                    } catch {
                        try Auth.auth().signOut()
                        promise(.failure(LogInError.unkownError))
                    }
                    
                    let splitUserEmail = currentUser.email?.split(separator: "@")
                    guard let subString = splitUserEmail?[0] else {
                        promise(.failure(LogInError.unkownError))
                        return
                    }
                    let usernameFromEmail = String(subString)
                    let isStore = splitUserEmail?[safe: 0]?.split(separator: "_").last == "Store"
                    guard ReduxStore.shared.customerModel == nil else {
                        //TODO: correct UserName
                        if isStore {
                            promise(.success(LogInModel(id: currentUser.uid, userName: ReduxStore.shared.customerModel!.userName, email: currentUser.uid, isStore: true)))
                        } else {
                            promise(.success(LogInModel(id: currentUser.uid, userName: ReduxStore.shared.customerModel!.userName, email: ReduxStore.shared.customerModel!.email, isStore: false)))
                        }
                        return
                    }
                    
                    if isStore {
                        self.database.child("stores/\(currentUser.uid)").observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            guard let name = postDict["name"] as? String,
                                  let details = postDict["cardDetails"] as? [String: AnyObject],
                                  let numberOfStampsBeforeReward = details["numberBeforeReward"] as? Int,
                                  let numberOfColumns = details["numberOfColumns"] as? Int,
                                  let numberOfRows = details["numberOfRows"] as? Int
                            else {
                                promise(.failure(LogInError.unkownError))
                                return
                            }
                            ReduxStore.shared.changeState(storeModel: StoreModel(storeName: name,
                                                                                 storeId: currentUser.uid,
                                                                                 numberOfRows: numberOfRows,
                                                                                 numberOfColumns: numberOfColumns,
                                                                                 numberOfStampsBeforeReward: numberOfStampsBeforeReward))
                            promise(.success(LogInModel(id: currentUser.uid, userName: name, email: currentUser.uid, isStore: true)))
                        })
                    } else {
                        self.database.child("users/\(currentUser.uid)").observe(DataEventType.value, with: { (snapshot) in
                            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                            guard let email = postDict["email"] as? String,
                                  let name = postDict["name"] as? String
                            else {
                                promise(.failure(LogInError.unkownError))
                                return
                            }
                            let stampCards: [CardData] = cards(from: postDict)
                            if ReduxStore.shared.customerModel == nil {
                                ReduxStore.shared.changeState(customerModel: CustomerModel(userId: currentUser.uid, email: email, userName: name, stampCards: stampCards))
                            }
                            promise(.success(LogInModel(id: currentUser.uid, userName: name, email: usernameFromEmail, isStore: false)))
                        })
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUp(email: String, userName: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, LogInError> {
        Deferred {
            Future {  [weak self] promise in
                
                let splitEmail = email.split(separator: "@")
                guard let self = self,
                      let part1 = splitEmail[safe: 0],
                      let part2 = splitEmail[safe: 1]
                else {
                    promise(.failure(LogInError.unkownError))
                    return
                }
                
                let emailWithSuffix = isStore ? "\(part1)_Store@\(part2)" : email
                print(emailWithSuffix)
                Auth.auth().createUser(withEmail: emailWithSuffix, password: password) { result, error in
                    guard let result = result else {
                        if let error = error {
                            if let errorCode = AuthErrorCode(rawValue: error._code) {
                                promise(.failure(LogInAPI.logInError(from: errorCode)))
                            }
                            promise(.failure(LogInError.unkownError))
                        } else {
                            promise(.failure(LogInError.unkownError))
                        }
                        return
                    }
                    if isStore {
                        let dic: NSDictionary = ["email": email,
                                                 "name": userName,
                                                 "cardDetails":
                                                    ["numberBeforeReward": 4,
                                                     "numberOfColumns": 4,
                                                     "numberOfRows": 5
                                                    ]
                        ]
                        
                        self.database.child("stores/\(result.user.uid)").setValue(dic) { error,_  in
                            guard error == nil else {
                                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                    promise(.failure(LogInAPI.logInError(from: errorCode)))
                                } else {
                                    promise(.failure(LogInError.unkownError))
                                }
                                return
                            }
                            ReduxStore.shared.changeState(storeModel: StoreModel(storeName: userName, storeId: result.user.uid))
                            promise(.success(SignUpModel(userName: userName, email: email, id: result.user.uid)))
                        }
                    } else {
                        let dic: NSDictionary = [
                            "email": email,
                            "name": userName
                        ]
                        self.database.child("users/\(result.user.uid)").setValue(dic){ error,_  in
                            guard error == nil else {
                                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                    promise(.failure(LogInAPI.logInError(from: errorCode)))
                                } else {
                                    promise(.failure(LogInError.unkownError))
                                }
                                return
                            }
                            ReduxStore.shared.changeState(customerModel: CustomerModel(userId: result.user.uid, email: email, userName: userName, stampCards: []))
                            promise(.success(SignUpModel(userName: userName, email: email, id: result.user.uid)))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
