//
//  LogInViewModule.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
class LogInViewModule: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var logInSuccess = false
    
    func login() {
        guard let s = try? encryptMessage(message: username, encryptionKey: password), let ss = try? decryptMessage(encryptedMessage: s, encryptionKey: password) else {
            return
        }
        
        if ss == username {
            logInSuccess = true
        }
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
