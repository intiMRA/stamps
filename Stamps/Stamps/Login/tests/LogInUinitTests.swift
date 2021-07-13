//
//  LogInUinitTests.swift
//  StampsTests
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import XCTest
@testable import Stamps
import FirebaseAuth
import Combine

class LogInUinitTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    func testLogInSucessfully() {
        let viewModel = LogInViewModel(api: MockLogInAPI())
        
        viewModel.isStore = false
        viewModel.username = "pete"
        viewModel.password = "password"
        
        viewModel.login()
        var expectation: XCTestExpectation? = self.expectation(description: "wating for log in")
        
        viewModel.$logInSuccess
            .dropFirst()
            .sink { success in
                if success {
                    expectation?.fulfill()
                    expectation = nil
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
    }

}

class MockLogInAPI: LogInAPIProtocol {
    var error: AuthErrorCode?
    func login(username: String, password: String, isStore: Bool) -> AnyPublisher<LogInModel, LogInError> {
        if let error = error {
            return Fail(error: LogInAPI.logInError(from: error))
                .eraseToAnyPublisher()
        }
        return Just(LogInModel(userName: username, isStore: isStore))
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    func logInUserAlreadySignedIn() -> AnyPublisher<LogInModel, LogInError> {
        if let error = error {
            return Fail(error: LogInAPI.logInError(from: error))
                .eraseToAnyPublisher()
        }
        return Just(LogInModel(userName: "test name", isStore: false))
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    func signUp(username: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, LogInError> {
        if let error = error {
            return Fail(error: LogInAPI.logInError(from: error))
                .eraseToAnyPublisher()
        }
        return Just(SignUpModel(name: username, id: "id"))
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    
}
