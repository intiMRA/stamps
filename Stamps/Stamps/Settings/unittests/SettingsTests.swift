//
//  SettingsTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 21/09/21.
//

import XCTest
@testable import Stamps
import Combine

class SettingsTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
    
    func testLogOut() {
        let api = MocLogOutAPI()
        let vm = SettingsViewModel(api: api)
        
        vm.$isLoggedOut
            .dropFirst()
            .sink { loggedOut in
                XCTAssertTrue(loggedOut)
            }
            .store(in: &cancellable)
        
        vm.logOut()
    }

}

class MocLogOutAPI: LogOutAPIProtocol {
    func logout() -> AnyPublisher<Void, LogInError> {
        Just(())
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    
}
