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
//    var cancellable = Set<AnyCancellable>()
//    func testClaimSlot() {
//        let card = [[CardSlot(isStamped: true, index: "0_0"), CardSlot(isStamped: false, index: "0_1", hasIcon: true)], [CardSlot(isStamped: true, index: "1_0"), CardSlot(isStamped: false, index: "1_1", hasIcon: true)]]
//        let cardData = CardData(card: card, storeName: "Store", storeId: "id", listIndex: 0, nextToStamp: (row: 1, col: 0), numberOfRows: 2, numberOfColumns: 2, numberOfStampsBeforeReward: 2)
//        let mockStore = MockReduxStore()
//        mockStore.customerModel = CustomerModel(userId: "id", email: "testname", userName: "pete", stampCards: [cardData])
//        let api = MockStampsAPI()
//        let cardCustomizationAPI = MockCardCustomizationAPI()
//        let vm = CardViewModel(cardData: cardData, api: api, showSubmitButton: false, cardCustomizationAPI: cardCustomizationAPI, reduxStore: mockStore)
//        var claimExpectation: XCTestExpectation? = self.expectation(description: "wait for claiming")
//        var alertExpectation: XCTestExpectation? = self.expectation(description: "wait for alert")
//        
//        //run
//        vm.claim("0_1")
//        
//        //verify
//        vm.$showAlert
//            .dropFirst()
//            .sink { showAlert in
//                XCTAssertTrue(showAlert)
//                vm.alertContent?.handler()
//                alertExpectation?.fulfill()
//                alertExpectation = nil
//            }
//            .store(in: &cancellable)
//        
//        vm.$stamps
//            .dropFirst()
//            .sink { card in
//                XCTAssertTrue(card.card[0][1].claimed)
//                XCTAssertTrue(mockStore.customerModel?.stampCards[0].card[0][1].claimed == true)
//                claimExpectation?.fulfill()
//                claimExpectation = nil
//            }
//            .store(in: &cancellable)
//        waitForExpectations(timeout: 10)
//    }
//    
//    func testClaimSlotAllClaimed() {
//        let api = MockStampsAPI()
//        let cardCustomizationAPI = MockCardCustomizationAPI()
//        let card = [[CardSlot(isStamped: true, index: "0_0"), CardSlot(isStamped: true, index: "0_1", claimed: true)], [CardSlot(isStamped: true, index: "1_0"), CardSlot(isStamped: true, index: "1_1", claimed: true)]]
//        let cardData = CardData(card: card, storeName: "testStore", storeId: "testId", listIndex: 0, nextToStamp: (row: 1, col: 0), numberOfRows: 2, numberOfColumns: 2, numberOfStampsBeforeReward: 2)
//        let mockStore = MockReduxStore()
//        mockStore.customerModel = CustomerModel(userId: "testId", email: "testname", userName: "pete", stampCards: [cardData])
//        let vm = CardViewModel(cardData: cardData, api: api, showSubmitButton: false, cardCustomizationAPI: cardCustomizationAPI, reduxStore: mockStore)
//        var claimExpectation: XCTestExpectation? = self.expectation(description: "wait for claiming")
//        var alertExpectation: XCTestExpectation? = self.expectation(description: "wait for alert")
//        
//        //run
//        vm.claim("0_1")
//        
//        //verify
//        vm.$showAlert
//            .dropFirst()
//            .sink { showAlert in
//                XCTAssertTrue(showAlert)
//                vm.alertContent?.handler()
//                alertExpectation?.fulfill()
//                alertExpectation = nil
//            }
//            .store(in: &cancellable)
//        
//        vm.$stamps
//            .dropFirst()
//            .sink { card in
//                XCTAssertFalse(card.card[0][1].claimed)
//                claimExpectation?.fulfill()
//                claimExpectation = nil
//            }
//            .store(in: &cancellable)
//        waitForExpectations(timeout: 10)
//        XCTAssertTrue(mockStore.customerModel?.stampCards[0].card[0][1].claimed == false)
//    }
//}
//
//class MockReduxStore: ReduxStoreProtocol {
//    var customerModel: CustomerModel?
//    
//    var storeModel: StoreModel?
//    
//    func addCard(_ card: CardData) {
//        self.customerModel = self.customerModel?.replaceCard(card)
//    }
//    
//    func changeState(customerModel: CustomerModel?, storeModel: StoreModel?) {
//        self.customerModel = customerModel
//        self.storeModel = storeModel
//    }
}
