//
//  SignUpUnitTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 17/07/21.
//

import XCTest
@testable import Stamps
import FirebaseAuth
import Combine

class SignUpUnitTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
    
    func testSignUpSuccessfully() {
        let api = MockLogInAPI()
        let vm = SignUpViewModel(api: api)
        vm.name = "pete"
        vm.password = "password"
        vm.isStore = false
        
        vm.signUp()
        
        var idExpectation: XCTestExpectation? = self.expectation(description: "wait for id")
        vm.$id
            .dropFirst()
            .sink { id in
                XCTAssertEqual("id", id)
                idExpectation?.fulfill()
                idExpectation = nil
            }
            .store(in: &cancellable)
        
        var signUpExpectation: XCTestExpectation? = self.expectation(description: "wait for signin")
        
        vm.$signUpSuccessfully
            .dropFirst()
            .sink { signUpSuccessfully in
                if signUpSuccessfully {
                    signUpExpectation?.fulfill()
                    signUpExpectation = nil
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual("pete", vm.name)
    }
    
    func testSignUpShouldFail() {
        let api = MockLogInAPI()
        api.error = .internalError
        let vm = SignUpViewModel(api: api)
        vm.name = "pete"
        vm.password = "password"
        vm.isStore = false
        
        vm.signUp()
        
        var alertExpectation: XCTestExpectation? = self.expectation(description: "wait for alert")
        vm.$showAlert
            .dropFirst()
            .sink { showAlert in
                if showAlert {
                    alertExpectation?.fulfill()
                    alertExpectation = nil
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(vm.error?.title, LogInAPI.logInError(from: .internalError).title)
        XCTAssertEqual(vm.error?.message, LogInAPI.logInError(from: .internalError).message)
    }
    
    func testSignUpAsStoreSuccessfully() {
        let api = MockLogInAPI()
        let vm = SignUpViewModel(api: api)
        vm.name = "pete"
        vm.password = "password"
        vm.isStore = true
        
        vm.signUp()
        
        var idExpectation: XCTestExpectation? = self.expectation(description: "wait for id")
        vm.$id
            .dropFirst()
            .sink { id in
                XCTAssertEqual("id", id)
                idExpectation?.fulfill()
                idExpectation = nil
            }
            .store(in: &cancellable)
        
        var signUpExpectation: XCTestExpectation? = self.expectation(description: "wait for signin")
        
        vm.$signUpSuccessfully
            .dropFirst()
            .sink { signUpSuccessfully in
                if signUpSuccessfully {
                    signUpExpectation?.fulfill()
                    signUpExpectation = nil
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual("pete", vm.name)
    }
    
    func testSignUpAsStoreShouldFail() {
        let api = MockLogInAPI()
        api.error = .internalError
        let vm = SignUpViewModel(api: api)
        vm.name = "pete"
        vm.password = "password"
        vm.isStore = true
        
        vm.signUp()
        
        var alertExpectation: XCTestExpectation? = self.expectation(description: "wait for alert")
        vm.$showAlert
            .dropFirst()
            .sink { showAlert in
                if showAlert {
                    alertExpectation?.fulfill()
                    alertExpectation = nil
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(vm.error?.title, LogInAPI.logInError(from: .internalError).title)
        XCTAssertEqual(vm.error?.message, LogInAPI.logInError(from: .internalError).message)
    }

}
