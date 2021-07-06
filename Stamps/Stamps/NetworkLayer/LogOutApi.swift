//
//  LogOutApi.swift
//  Stamps
//
//  Created by Inti Albuquerque on 21/06/21.
//

import Foundation

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

class LogOutApi {
    
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
