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
    var cancellable = Set<AnyCancellable>()
    func testLogInSuccessfully() {
        let viewModel = LogInViewModel(api: MockLogInAPI())
        
        viewModel.isStore = false
        viewModel.email = "pete"
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
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
    }
    
    func testLogInShouldFail() {
        let api = MockLogInAPI()
        api.error = .internalError
        let viewModel = LogInViewModel(api: api)
        
        viewModel.isStore = false
        viewModel.email = "pete"
        viewModel.password = "password"
        
        viewModel.login()
        var expectation: XCTestExpectation? = self.expectation(description: "wating for log in")
        
        viewModel.$showAlert
            .dropFirst()
            .sink { showAlert in
                if showAlert {
                    expectation?.fulfill()
                    expectation = nil
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(viewModel.error?.title, LogInAPI.logInError(from: .internalError).title)
        XCTAssertEqual(viewModel.error?.message, LogInAPI.logInError(from: .internalError).message)
    }
    
    func testLogInAsStoreSuccessfully() {
        let viewModel = LogInViewModel(api: MockLogInAPI())
        
        viewModel.isStore = true
        viewModel.email = "pete"
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
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
    }
    
    func testLogInAsStoreShouldFail() {
        let api = MockLogInAPI()
        api.error = .internalError
        let viewModel = LogInViewModel(api: api)
        
        viewModel.isStore = true
        viewModel.email = "pete"
        viewModel.password = "password"
        
        viewModel.login()
        var expectation: XCTestExpectation? = self.expectation(description: "wating for log in")
        
        viewModel.$showAlert
            .dropFirst()
            .sink { showAlert in
                if showAlert {
                    expectation?.fulfill()
                    expectation = nil
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(viewModel.error?.title, LogInAPI.logInError(from: .internalError).title)
        XCTAssertEqual(viewModel.error?.message, LogInAPI.logInError(from: .internalError).message)
    }

}

class MockLogInAPI: LogInAPIProtocol {
    var error: AuthErrorCode?
    func login(email: String, password: String, isStore: Bool) -> AnyPublisher<LogInModel, LogInError> {
        if let error = error {
            return Fail(error: LogInAPI.logInError(from: error))
                .eraseToAnyPublisher()
        }
        return Just(LogInModel(un: "", email: email, isStore: isStore))
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    func logInUserAlreadySignedIn() -> AnyPublisher<LogInModel, LogInError> {
        if let error = error {
            return Fail(error: LogInAPI.logInError(from: error))
                .eraseToAnyPublisher()
        }
        return Just(LogInModel(un: "", email: "test name", isStore: false))
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String, isStore: Bool) -> AnyPublisher<SignUpModel, LogInError> {
        if let error = error {
            return Fail(error: LogInAPI.logInError(from: error))
                .eraseToAnyPublisher()
        }
        return Just(SignUpModel(name: email, id: "id"))
            .setFailureType(to: LogInError.self)
            .eraseToAnyPublisher()
    }
    
    
}
