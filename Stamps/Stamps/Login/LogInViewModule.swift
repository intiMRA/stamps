//
//  LogInViewModule.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine
class LogInViewModule: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var logInSuccess = false
    private var cancellables = Set<AnyCancellable>()
    private let api = LogInAPI()
    
    func login() {
        guard !password.isEmpty, !username.isEmpty else {
            return
        }
        api.login(username: username, password: password).sink (receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.logInSuccess = false
            }
            
        }, receiveValue: { module in
            if module.userName == self.username {
                self.logInSuccess = true
            }
        })
        .store(in: &cancellables)
    }
}
