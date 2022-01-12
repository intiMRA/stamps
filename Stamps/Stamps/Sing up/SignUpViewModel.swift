//
//  SignUpViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 6/05/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var userName = ""
    @Published var email = ""
    @Published var id = ""
    @Published var password = ""
    @Published var isStore = false
    @Published var signUpSuccessfully = false
    @Published var showAlert = false
    var error: LogInError?
    private let api: LogInAPIProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(api: LogInAPIProtocol = LogInAPI()) {
        self.api = api
    }
    
    func signUp() {
        guard !password.isEmpty, !email.isEmpty else {
            return
        }
        api.signUp(email: email, userName: userName, password: password, isStore: isStore)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.showAlert = true
                    self.error = error
                }
            }, receiveValue: { model in
                self.email = model.email
                self.id = model.id
                self.userName = model.userName
                self.signUpSuccessfully = true
            })
            .store(in: &cancellable)
    }
}
