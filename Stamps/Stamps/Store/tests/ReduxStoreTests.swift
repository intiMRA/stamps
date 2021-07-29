//
//  ReduxStoreTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 17/07/21.
//

import XCTest
@testable import Stamps
import FirebaseAuth
import Combine

class ReduxStoreTests: XCTestCase {
    
    func testchangeState() {
        let reduxStore = ReduxStore()
        XCTAssertNil(reduxStore.customerModel)
        XCTAssertNil(reduxStore.storeModel)
        
        
        let card = CardData(card: [[]], storeName: "the store", storeId: "id", listIndex: 1, nextToStamp: (row: 0, col: 0), numberOfRows: 0, numberOfColums: 0, numberOfStampsBeforeReward: 0)
        
        let customerModel = CustomerModel(userId: "customerId", username: "pete", stampCards: [card])
        
        ReduxStore.shared.changeState(customerModel: customerModel)
        
        XCTAssertEqual(reduxStore.customerModel, customerModel)
        XCTAssertNil(reduxStore.storeModel)
        
        let storeModel = StoreModel(storeName: "the store", storeId: "storeId")
        
        reduxStore.changeState(storeModel: storeModel)
        XCTAssertEqual(ReduxStore.shared.customerModel, customerModel)
        XCTAssertEqual(ReduxStore.shared.storeModel, storeModel)
        
    }
    
    func testAddCard() {
        let reduxStore = ReduxStore()
        XCTAssertNil(reduxStore.customerModel)
        XCTAssertNil(reduxStore.storeModel)
        
        
        let card = CardData(card: [[]], storeName: "the store", storeId: "id", listIndex: 1, nextToStamp: (row: 0, col: 0), numberOfRows: 0, numberOfColums: 0, numberOfStampsBeforeReward: 0)
        
        let customerModel = CustomerModel(userId: "customerId", username: "pete", stampCards: [])
        
        reduxStore.changeState(customerModel: customerModel)
        
        XCTAssertEqual([], ReduxStore.shared.customerModel?.stampCards)
        reduxStore.addCard(card)
        XCTAssertEqual(card, ReduxStore.shared.customerModel?.stampCards[0])
        
        
    }

}
