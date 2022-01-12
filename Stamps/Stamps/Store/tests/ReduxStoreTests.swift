//
//  ReduxStoreTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 17/07/21.
//

import XCTest
@testable import Stamps
import Combine

class ReduxStoreTests: XCTestCase {
    
    func testchangeState() async {
        await ReduxStore.shared.setNill()

//        XCTAssertNil(ReduxStore.shared.storeModel)
        
        
        let card = CardData(card: [[]], storeName: "the store", storeId: "id", listIndex: 1, nextToStamp: (row: 0, col: 0), numberOfRows: 0, numberOfColumns: 0, numberOfStampsBeforeReward: 0)
        
        let customerModel = CustomerModel(userId: "customerId", email: "pete", userName: "pete", stampCards: [card])
        
        await ReduxStore.shared.changeState(customerModel: customerModel)
//
//        XCTAssertEqual(ReduxStore.shared.customerModel, customerModel)
//        XCTAssertNil(ReduxStore.shared.storeModel)
        
        let storeModel = StoreModel(storeName: "the store", storeId: "storeId", numberOfRows: 5, numberOfColumns: 4, numberOfStampsBeforeReward: 4)
        
        await ReduxStore.shared.changeState(storeModel: storeModel)
//        XCTAssertEqual(ReduxStore.shared.customerModel, customerModel)
//        XCTAssertEqual(ReduxStore.shared.storeModel, storeModel)
        
    }
    
    func testAddCard() async {
        await ReduxStore.shared.setNill()
//        XCTAssertNil(ReduxStore.shared.customerModel)
//        XCTAssertNil(ReduxStore.shared.storeModel)
        
        
        let card = CardData(card: [[]], storeName: "the store", storeId: "id", listIndex: 1, nextToStamp: (row: 0, col: 0), numberOfRows: 0, numberOfColumns: 0, numberOfStampsBeforeReward: 0)
        
        let customerModel = CustomerModel(userId: "customerId", email: "pete", userName: "pete", stampCards: [])
        
        await ReduxStore.shared.changeState(customerModel: customerModel)
        
        //XCTAssertEqual([], ReduxStore.shared.customerModel?.stampCards)
        await ReduxStore.shared.addCard(card)
        //XCTAssertEqual(card, ReduxStore.shared.customerModel?.stampCards[0])
        
        
    }

}
