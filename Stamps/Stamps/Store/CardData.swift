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
    let claimed: Bool
    init(isStamped: Bool, index: String, hasIcon: Bool = false, claimed: Bool = false) {
        self.isStamped = isStamped
        self.index = index
        self.hasIcon = hasIcon
        self.claimed = claimed
    }
    
    func claim(previousSlot: CardSlot) -> CardSlot? {
        guard previousSlot.isStamped else {
            return nil
        }
        
        return CardSlot(isStamped: self.isStamped, index: self.index, hasIcon: self.hasIcon, claimed: true)
    }
    
    func stamp() -> CardSlot {
        CardSlot(isStamped: true, index: self.index, hasIcon: self.hasIcon, claimed: self.claimed)
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
            let slot = row[lastIndex.col]
            row[lastIndex.col] = slot.stamp()
            guard lastIndex.col + 2 < row.count else {
                return CardData(row1: row, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .two, col: 0))
            }
            return CardData(row1: row, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .two:
            var row = row2
            let slot = row[lastIndex.col]
            row[lastIndex.col] = slot.stamp()
            guard lastIndex.col + 2 < row.count else {
                return CardData(row1: row1, row2: row, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .three, col: 0))
            }
            return CardData(row1: row1, row2: row, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .three:
            var row = row3
            let slot = row[lastIndex.col]
            row[lastIndex.col] = slot.stamp()
            guard lastIndex.col + 2 < row.count else {
                return CardData(row1: row1, row2: row2, row3: row, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .four, col: 0))
            }
            return CardData(row1: row1, row2: row2, row3: row, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .four:
            var row = row4
            let slot = row[lastIndex.col]
            row[lastIndex.col] = slot.stamp()
            guard lastIndex.col + 2 < row.count else {
                return CardData(row1: row1, row2: row2, row3: row3, row4: row, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: .five, col: 0))
            }
            return CardData(row1: row1, row2: row2, row3: row3, row4: row, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        case .five:
            var row = row5
            let slot = row[lastIndex.col]
            row[lastIndex.col] = slot.stamp()
            guard lastIndex.col + 2 < row.count else {
                //TODO tell customer to claim rewards
                return self
            }
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: (row: lastIndex.row, col: lastIndex.col + 1))
        }
    }
    
    static func newCard(storeName: String, storeId: String, listIndex: Int?, firstStamp: Bool = true) -> CardData {
        let row1 = [CardSlot(isStamped: firstStamp, index: "\(RowIndex.one.rawValue)_0"),
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
        
        return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex ?? 0, lastIndex: (row: .one, col: 1))
    }
    
    func claim(index: String) -> CardData? {
        guard
            let row = RowIndex(rawValue: String(index.split(separator: "_")[0])),
            String(index.split(separator: "_")[1]) == String(row1.count - 1)
        else {
            return self
        }
        switch row {
        case .one:
            var row1 = self.row1
            guard let slot = row1[row1.count - 1].claim(previousSlot: row1[row1.count - 2]) else {
                return nil
            }
            var lastIndex = self.lastIndex
            
            if lastIndex.row == row {
                lastIndex = (row: .two, col: 0)
            }
            
            row1[row1.count - 1] = slot.stamp()
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: lastIndex)
        case .two:
            var row2 = self.row2
            guard let slot = row2[row2.count - 1].claim(previousSlot: row2[row2.count - 2]) else {
                return nil
            }
            var lastIndex = self.lastIndex
            
            if lastIndex.row == row {
                lastIndex = (row: .three, col: 0)
            }
            
            row2[row2.count - 1] = slot.stamp()
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: lastIndex)
        case .three:
            var row3 = self.row3
            guard let slot = row3[row3.count - 1].claim(previousSlot: row3[row3.count - 2]) else {
                return nil
            }
            
            var lastIndex = self.lastIndex
            
            if lastIndex.row == row {
                lastIndex = (row: .four, col: 0)
            }
            
            row3[row3.count - 1] = slot.stamp()
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: lastIndex)
        case .four:
            var row4 = self.row4
            guard let slot = row4[row4.count - 1].claim(previousSlot: row4[row4.count - 2]) else {
                return nil
            }
            
            var lastIndex = self.lastIndex
            
            if lastIndex.row == row {
                lastIndex = (row: .five, col: 0)
            }
            
            row4[row4.count - 1] = slot.stamp()
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: lastIndex)
        case .five:
            var row5 = self.row5
            guard let slot = row5[row5.count - 1].claim(previousSlot: row5[row5.count - 2]) else {
                return nil
            }
            row5[row5.count - 1] = slot.stamp()
            return CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5, storeName: storeName, storeId: storeId, listIndex: listIndex, lastIndex: lastIndex)
        }
    }
}
