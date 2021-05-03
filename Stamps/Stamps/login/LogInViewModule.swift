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
        logInSuccess = true
    }
}
