//
//  LogInAPI.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 4/05/21.
//

import Foundation
import Combine

struct LogInModel {
    let userName: String
}

struct SignUpModel {
    let userName: String
}

class LogInAPI {
    func login(username: String, password: String) -> AnyPublisher<LogInModel, Error> {
        Deferred {
            Future { [self] promise in
                guard let s = try? encryptMessage(message: username, encryptionKey: password), let ss = try? decryptMessage(encryptedMessage: s, encryptionKey: password) else {
                    promise(.failure(NSError(domain: "", code: 1, userInfo: nil)))
                    return
                }
                if ss == username {
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
