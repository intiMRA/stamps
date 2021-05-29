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
    let lastIndex: (row: RowIndex, col: Int)
    let storeName: String
    let storeId: String
    let listIndex: Int
    
    init(row1: [CardSlot] = [], row2: [CardSlot] = [], row3: [CardSlot] = [], row4: [CardSlot] = [], row5: [CardSlot] = [], storeName: String, storeId: String, listIndex: Int, lastIndex: (row: RowIndex, col: Int) = (row: RowIndex.one, col: 0)) {
        self.row1 = row1
        self.row2 = row2
        self.row3 = row3
        self.row4 = row4
        self.row5 = row5
        self.storeName = storeName
        self.lastIndex = lastIndex
        self.listIndex = listIndex
        self.storeId = storeId
    }
    
    func stamp() -> CardData {
        switch lastIndex.row {
        case .one:
            var row = row1
            row[lastIndex.col] = CardSlot(isStamped: true, index: row[lastIndex.col].index, hasIcon: row[lastIndex.col].hasIcon)
            guard lastIndex.col + 1 < row.count else {
                return CardData(row1: row, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .two, col: 0))
            }
            return CardData(row1: row, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .two:
            var row = row2
            row[lastIndex.col] = CardSlot(isStamped: true, index: row[lastIndex.col].index, hasIcon: row[lastIndex.col].hasIcon)
            guard lastIndex.col + 1 < row.count else {
                return CardData(row1: row1, row2: row, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .three, col: 0))
            }
            return CardData(row1: row1, row2: row, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .three:
            var row = row3
            row[lastIndex.col] = CardSlot(isStamped: true, index: row[lastIndex.col].index, hasIcon: row[lastIndex.col].hasIcon)
            guard lastIndex.col + 1 < row.count else {
                return CardData(row1: row1, row2: row2, row3: row, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .four, col: 0))
            }
            return CardData(row1: row1, row2: row2, row3: row, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .four:
            var row = row4
            row[lastIndex.col] = CardSlot(isStamped: true, index: row[lastIndex.col].index, hasIcon: row[lastIndex.col].hasIcon)
            guard lastIndex.col + 1 < row.count else {
                return CardData(row1: row1, row2: row2, row3: row3, row4: row, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .five, col: 0))
            }
            return CardData(row1: row1, row2: row2, row3: row3, row4: row, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .five:
            var row = row5
            row[lastIndex.col] = CardSlot(isStamped: true, index: row[lastIndex.col].index, hasIcon: row[lastIndex.col].hasIcon)
            guard lastIndex.col + 1 < row.count else {
                let row1 = self.row1.map { CardSlot(isStamped: false, index: $0.index, hasIcon: $0.hasIcon) }
                let row2 = self.row2.map { CardSlot(isStamped: false, index: $0.index, hasIcon: $0.hasIcon) }
                let row3 = self.row3.map { CardSlot(isStamped: false, index: $0.index, hasIcon: $0.hasIcon) }
                let row4 = self.row4.map { CardSlot(isStamped: false, index: $0.index, hasIcon: $0.hasIcon) }
                let row5 = self.row5.map { CardSlot(isStamped: false, index: $0.index, hasIcon: $0.hasIcon) }
                return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .one, col: 0))
            }
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        }
    }
    
    static func newCard(storeName: String, storeId: String, listIndex: Int?) -> CardData {
        let row1 = [CardSlot(isStamped: true, index: "\(RowIndex.one.rawValue)_0"),
                    CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_1"),
                    CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_2"),
                    CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_3", hasIcon: true)]
        
        let row2 = [CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_0"),
                    CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_1"),
                    CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_2"),
                    CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_3", hasIcon: true)]
        
        let row3 = [CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_0"),
                    CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_1"),
                    CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_2"),
                    CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_3", hasIcon: true)]
        
        let row4 = [CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_0"),
                    CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_1"),
                    CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_2"),
                    CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_3", hasIcon: true)]
        
        let row5 = [CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_0"),
                    CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_1"),
                    CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_2"),
                    CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_3", hasIcon: true)]
        
        return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex ?? 0)
    }
}
