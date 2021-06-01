//
//  LogInViewModule.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine
class LogInViewModule: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var logInSuccess = false
    @Published var showAlert = false
    var error: LogInError?
    var isStore = false
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
            case let .failure(error):
                self?.showAlert = true
                self?.error = error
            }
            
        }, receiveValue: { module in
            if module.userName == self.username {
                self.logInSuccess = true
            }
        })
        .store(in: &cancellables)
    }
}
