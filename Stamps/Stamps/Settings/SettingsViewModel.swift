//
//  SettingsView.swift
//  Stamps
//
//  Created by Inti Albuquerque on 21/06/21.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isLoggedOut = false
    @Published var shouldShowAlert = false
    @Published var showCardCustomisation = false
    private var cancellables = Set<AnyCancellable>()
    let api = LogOutApi()
    
    @objc
    func logOut() {
        api.logout()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.shouldShowAlert = true
                }
                
            }, receiveValue: { [weak self] in
                self?.isLoggedOut = true
            })
            .store(in: &cancellables)
    }
}
