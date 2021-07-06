//
//  LogInViewModule.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine
enum LogInType: String {
    case loading, store, user, notLoggedIn
}

class LogInViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var logInSuccess = false
    @Published var showAlert = false
    @Published var isStore = false
    @Published var state: LogInType = .loading
    var error: LogInError?
    private var cancellables = Set<AnyCancellable>()
    private let api = LogInAPI()
    
    func login() {
        guard !password.isEmpty, !username.isEmpty else {
            return
        }
        api.login(username: username, password: password, isStore: isStore)
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                self?.showAlert = true
                self?.error = error
            }
            
        }, receiveValue: { model in
            if model.userName == self.username {
                self.logInSuccess = true
            }
        })
        .store(in: &cancellables)
    }
    
    func logInUserAlreadySignedIn() {
        api.logInUserAlreadySignedIn()
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case _:
                    self?.state = .notLoggedIn
                }
                
            }, receiveValue: { model in
                if model.isStore {
                    self.state = .store
                    self.username = model.userName
                } else {
                    self.state = .user
                }
            })
            .store(in: &cancellables)
    }
}
