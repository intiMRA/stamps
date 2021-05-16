//
//  SignUpViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 6/05/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isStore = false
    @Published var signUpSuccessfully = false
    private let api = LogInAPI()
    private var cancellables = Set<AnyCancellable>()
    
    func signUp() {
        guard !password.isEmpty, !username.isEmpty else {
            return
        }
        api.signUp(username: username, password: password, isStore: isStore)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            }, receiveValue: { _ in
                self.signUpSuccessfully = true
            })
            .store(in: &cancellables)
    }
}
