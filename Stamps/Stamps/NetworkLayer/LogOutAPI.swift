//
//  LogOutAPI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 21/06/21.
//

import Foundation

import Foundation
import Combine
import FirebaseAuth

protocol LogOutAPIProtocol {
    func logout() -> AnyPublisher<Void, LogInError>
}

class LogOutAPI: LogOutAPIProtocol {
    
    func logout() -> AnyPublisher<Void, LogInError> {
        Deferred {
            Future { promise in
                do {
                    try  Auth.auth().signOut()
                    promise(.success(()))
                } catch {
                    promise(.failure(LogInError.unkownError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
