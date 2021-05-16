//
//  CardData.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/05/21.
//

import Foundation


struct CardSlot {
    let isStamped: Bool
    let index: String
    let hasIcon: Bool
    init(isStamped: Bool, index: String, hasIcon: Bool = false) {
        self.isStamped = isStamped
        self.index = index
        self.hasIcon = hasIcon
    }
}

enum RowIndex: String{
    case one
    case two
    case three
    case four
    case five
}

struct CardData {
    let row1: [CardSlot]
    let row2: [CardSlot]
    let row3: [CardSlot]
    let row4: [CardSlot]
    let row5: [CardSlot]
    let storeName: String
    
    init(row1: [CardSlot] = [], row2: [CardSlot] = [], row3: [CardSlot] = [], row4: [CardSlot] = [], row5: [CardSlot] = [], storeName: String = "The Store") {
        self.row1 = row1
        self.row2 = row2
        self.row3 = row3
        self.row4 = row4
        self.row5 = row5
        self.storeName = storeName
    }
    
    func changeAtIndex(at index: String) -> CardData {
        var changed = [CardSlot]()
        let indexes = index.split(separator: "_")
        guard let row = RowIndex(rawValue: String(indexes[0])), let indexNumber = Int(indexes[1]) else {
            return self
        }
        var changedCard = self
        switch row {
        case .one:
            changed = row1
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            changedCard = CardData(row1: changed, row2: row2, row3: row3, row4: row4, row5: row5)
        case .two:
            changed = row2
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            changedCard = CardData(row1: row1, row2: changed, row3: row3, row4: row4, row5: row5)
        case .three:
            changed = row3
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            changedCard = CardData(row1: row1, row2: row2, row3: changed, row4: row4, row5: row5)
        case .four:
            changed = row4
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            changedCard = CardData(row1: row1, row2: row2, row3: row3, row4: changed, row5: row5)
        case .five:
            changed = row5
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            changedCard = CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: changed)
        }
        ReduxStore.shared.customerModel?.stampCards[self.storeName] = changedCard
        return changedCard
    }
}
