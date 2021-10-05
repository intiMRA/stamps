//
//  CardCustomisationTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 9/08/21.
//

import XCTest
import Combine
@testable import Stamps

class CardCustomisationTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
    func testSubmit() {
        let api = MockCardCustomizationAPI()
        let vm = CardCustomisationViewModel(storeName: "storeName", storeId: "id", api: api)
        api.expectation = self.expectation(description: "waiting for submission")
        let alertExpectation = self.expectation(description: "waiting for alert")
        let navigationExpectation = self.expectation(description: "waiting for navigation")
        
        vm.submit()
        
        vm.$showAlert
            .sink { show in
                if show {
                    alertExpectation.fulfill()
                    vm.alertContent?.handler()
                }
            }
            .store(in: &cancellable)
        
        vm.$navigateToTabsView
            .sink { navigate in
                if navigate {
                    navigationExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10)
    }

}

class MockCardCustomizationAPI: CardCustomizationAPIProtocol {
    var expectation: XCTestExpectation?
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) -> AnyPublisher<Void, CardCustomizationError> {
        expectation?.fulfill()
        expectation = nil
        return Just(())
            .setFailureType(to: CardCustomizationError.self)
            .eraseToAnyPublisher()
    }
}
