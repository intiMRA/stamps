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
    var cancellables = Set<AnyCancellable>()
    func testSubmit() {
        let api = MockCardCustomizationAPI()
        let vm = CardCustomisationViewModel(storeName: "storeName", storeId: "id", api: api)
        api.expectation = self.expectation(description: "waiting for submission")
        let alertExpectation = self.expectation(description: "waiting for alert")
        let navigationtExpectation = self.expectation(description: "waiting for navigation")
        
        vm.submit()
        
        vm.$showAlert
            .sink { show in
                if show {
                    alertExpectation.fulfill()
                    vm.alertContent?.handler()
                }
            }
            .store(in: &cancellables)
        
        vm.$navigateToTabsView
            .sink { navigate in
                if navigate {
                    navigationtExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
    }

}

class MockCardCustomizationAPI: CardCustomizationAPIProtocol {
    var expectation: XCTestExpectation?
    func uploadNewCardDetails(numberOfRows: Int, numberOfColumns: Int, numberBeforeReward: Int, storeId: String) {
        expectation?.fulfill()
        expectation = nil
    }
}
