//
//  SignUpViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 6/05/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var id = ""
    @Published var password = ""
    @Published var isStore = false
    @Published var signUpSuccessfully = false
    @Published var showAlert = false
    var error: LogInError?
    private let api = LogInAPI()
    private var cancellables = Set<AnyCancellable>()
    
    func signUp() {
        guard !password.isEmpty, !name.isEmpty else {
            return
        }
        api.signUp(username: name, password: password, isStore: isStore)
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
                self.name = model.name
                self.id = model.id
                self.signUpSuccessfully = true
            })
            .store(in: &cancellables)
    }
}
