//
//  CardDataTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 17/07/21.
//

import XCTest
@testable import Stamps
import FirebaseAuth
import Combine

class CardDataTests: XCTestCase {

    func testStamp() {
        let card = CardData.newCard(storeName: "the store", storeId: "store id", listIndex: 0, firstIsStamped: false, numberOfRows: 5, numberOfColums: 4, stampsAfter: 4)
        let stamped = card.stamp()
        XCTAssertTrue(stamped?.card[0][0].isStamped == true)
        XCTAssertTrue(stamped?.card[0][1].isStamped == false)
    }
    
    func testClaimingCard() {
        var card = CardData(card: [[CardSlot(isStamped: true, index: "0_0", hasIcon: false, claimed: false), CardSlot(isStamped: true, index: "0_1", hasIcon: true, claimed: false)]], storeName: "the store", storeId: "storid", listIndex: 0, nextToStamp: (row: 0, col: 1), numberOfRows: 1, numberOfColums: 2, stampsAfter: 2)
        
        XCTAssertFalse(card.allSlotsAreClaimed())
        
        card = card.claim(index: "0_1")!
        
        XCTAssertTrue(card.card[0][1].claimed)
        XCTAssertTrue(card.allSlotsAreClaimed())
        
    }
    
    func testClaimingNotStampedCard() {
        let card = CardData(card: [[CardSlot(isStamped: false, index: "0_0", hasIcon: false, claimed: false), CardSlot(isStamped: true, index: "0_1", hasIcon: true, claimed: false)]], storeName: "the store", storeId: "storid", listIndex: 0, nextToStamp: (row: 0, col: 1), numberOfRows: 1, numberOfColums: 2, stampsAfter: 2)
        
        XCTAssertNil(card.claim(index: "0_1"))
        XCTAssertFalse(card.allSlotsAreClaimed())
        
    }

}
