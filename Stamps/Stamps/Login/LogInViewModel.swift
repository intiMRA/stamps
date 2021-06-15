//
//  LogInViewModule.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine
class LogInViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var logInSuccess = false
    @Published var showAlert = false
    @Published var isStore = false
    var error: LogInError?
    private var cancellables = Set<AnyCancellable>()
    private let api = LogInAPI()
    
    func login() {
        guard !password.isEmpty, !username.isEmpty else {
            return
        }
        api.login(username: username, password: password, isStore: isStore).sink (receiveCompletion: { [weak self] completion in
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
