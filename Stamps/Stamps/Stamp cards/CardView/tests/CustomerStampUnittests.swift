//
//  CustomerStampUnittests.swift
//  StampsTests
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import XCTest
import Combine
@testable import Stamps

class CustomerStampUnittests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    func testClaimSlot() {
        let card = [[CardSlot(isStamped: true, index: "0_0"), CardSlot(isStamped: false, index: "0_1")], [CardSlot(isStamped: true, index: "1_0"), CardSlot(isStamped: false, index: "1_1")]]
        let cardData = CardData(card: card, storeName: "testStore", storeId: "testId", listIndex: 0, nextToStamp: (row: 1, col: 0), numberOfRows: 2, numberOfColums: 2, numberOfStampsBeforeReward: 2)
        let mockStore = MockReduxStore()
        mockStore.customerModel = CustomerModel(userId: "testid", username: "testname", stampCards: [cardData])
        let vm = CardViewModel(cardData: cardData, api: nil, showSubmitButton: false, cardCustomizationAPI: nil, reduxStore: mockStore)
        let claimExpectation = self.expectation(description: "wait for claiming")
        let alertExpectation = self.expectation(description: "wait for alert")
        
        //run
        vm.claim("0_1")
        
        //verify
        vm.$showAlert
            .sink { showAlert in
                XCTAssertTrue(showAlert)
                vm.alertContent?.handler()
                alertExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$stamps
            .sink { card in
                XCTAssertTrue(card.card[0][1].claimed)
                XCTAssertTrue(mockStore.customerModel?.stampCards[0].card[0][1].claimed == true)
                claimExpectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10)
    }
    
    func testClaimSlotAllClaimed() {
        let card = [[CardSlot(isStamped: true, index: "0_0"), CardSlot(isStamped: true, index: "0_1", claimed: true)], [CardSlot(isStamped: true, index: "1_0"), CardSlot(isStamped: true, index: "1_1", claimed: true)]]
        let cardData = CardData(card: card, storeName: "testStore", storeId: "testId", listIndex: 0, nextToStamp: (row: 1, col: 0), numberOfRows: 2, numberOfColums: 2, numberOfStampsBeforeReward: 2)
        let mockStore = MockReduxStore()
        mockStore.customerModel = CustomerModel(userId: "testid", username: "testname", stampCards: [cardData])
        let vm = CardViewModel(cardData: cardData, api: nil, showSubmitButton: false, cardCustomizationAPI: nil, reduxStore: mockStore)
        let claimExpectation = self.expectation(description: "wait for claiming")
        let alertExpectation = self.expectation(description: "wait for alert")
        
        //run
        vm.claim("0_1")
        
        //verify
        vm.$showAlert
            .sink { showAlert in
                XCTAssertTrue(showAlert)
                vm.alertContent?.handler()
                alertExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$stamps
            .dropFirst()
            .sink { card in
                XCTAssertFalse(card.card[0][1].claimed)
                claimExpectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10)
        XCTAssertTrue(mockStore.customerModel?.stampCards[0].card[0][1].claimed == false)
    }
}

class MockReduxStore: ReduxStoreProtocol {
    var customerModel: CustomerModel?
    
    var storeModel: StoreModel?
    
    func addCard(_ card: CardData) {
        self.customerModel = self.customerModel?.replaceCard(card)
    }
    
    func changeState(customerModel: CustomerModel?, storeModel: StoreModel?) {
        self.customerModel = customerModel
        self.storeModel = storeModel
    }
}
