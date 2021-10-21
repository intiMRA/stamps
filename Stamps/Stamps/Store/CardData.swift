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

struct CardData: Equatable {
    private static var hasFinishedCard = false
    let card: [[CardSlot]]
    let nextToStamp: (row: Int, col: Int)
    let storeName: String
    let storeId: String
    let listIndex: Int
    let numberOfRows: Int
    let numberOfColumns: Int
    let numberOfStampsBeforeReward: Int
    
    init(
        card: [[CardSlot]] = [[]],
        storeName: String,
        storeId: String,
        listIndex: Int,
        nextToStamp: (row: Int, col: Int) = (row: 0, col: 0),
        numberOfRows: Int,
        numberOfColumns: Int,
        numberOfStampsBeforeReward: Int) {
        self.card = card
        self.storeName = storeName
        self.nextToStamp = nextToStamp
        self.listIndex = listIndex
        self.storeId = storeId
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.numberOfStampsBeforeReward = numberOfStampsBeforeReward
    }
    
    func stamp() -> CardData? {
        
        let currentCol = nextToStamp.col
        
        guard nextToStamp.row < card.count else {
            return nil
        }
        
        var row = card[nextToStamp.row]
        var newCard = card
        let slot = row[currentCol]
        row[currentCol] = slot.stamp()
        newCard[nextToStamp.row] = row
        
        var nextRow = nextToStamp.row
        var nextCol = nextToStamp.col + 1
        
        // check if change row
        if currentCol == row.lastIndex() {
            nextRow += 1
            nextCol = 0
            
            //if the next row is the last we still need to stamp the last slot
            if nextRow == card.count {
                return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextRow, col: nextCol), numberOfRows: self.numberOfRows, numberOfColumns: self.numberOfColumns, numberOfStampsBeforeReward: self.numberOfStampsBeforeReward)
            }
        }
        
        guard nextRow < card.count else {
            return nil
        }
        
        guard !card[nextRow][nextCol].hasIcon else {
            if nextCol == row.lastIndex() {
                return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextRow + 1, col: 0), numberOfRows: self.numberOfRows, numberOfColumns: self.numberOfColumns, numberOfStampsBeforeReward: self.numberOfStampsBeforeReward)
            }
            
            //skip icon
            return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextRow, col: nextCol + 1), numberOfRows: self.numberOfRows, numberOfColumns: self.numberOfColumns, numberOfStampsBeforeReward: self.numberOfStampsBeforeReward)
        }
        
        return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextRow, col: nextCol), numberOfRows: self.numberOfRows, numberOfColumns: self.numberOfColumns, numberOfStampsBeforeReward: self.numberOfStampsBeforeReward)
    }
    
    static func newCard(storeName: String, storeId: String, listIndex: Int?, firstIsStamped: Bool = true, numberOfRows: Int, numberOfColumns: Int, numberOfStampsBeforeReward: Int) -> CardData {
        var newCard = [[CardSlot]]()
        var amountCreated = 0
        for row in 0 ..< numberOfRows {
            newCard.append([])
            for col in 0 ..< numberOfColumns {
                if row == 0, col == 0 {
                    newCard[row].append(CardSlot(isStamped: firstIsStamped, index: "\(row)_\(col)"))
                    amountCreated += 1
                } else if amountCreated == numberOfStampsBeforeReward - 1 {
                    newCard[row].append(CardSlot(isStamped: false, index: "\(row)_\(col)", hasIcon: true))
                    amountCreated = 0
                } else {
                    newCard[row].append(CardSlot(isStamped: false, index: "\(row)_\(col)"))
                    amountCreated += 1
                }
            }
        }
        
        return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex ?? 0, nextToStamp: (row: 0, col: firstIsStamped ? 1 : 0), numberOfRows: numberOfRows, numberOfColumns: numberOfColumns, numberOfStampsBeforeReward: numberOfStampsBeforeReward)
    }
    
    func claim(index: String) -> CardData? {
        guard
            let rowIndex = Int(String(index.split(separator: "_")[0])),
            let colIndex = Int(index.split(separator: "_")[1]),
            rowIndex < card.count,
            card[rowIndex][colIndex].hasIcon
        else {
            return self
        }
        
        //if previous index is negative, then set to the previous row
        let prevColIndex = colIndex - 1 >= 0 ? colIndex - 1 : card[0].lastIndex()
        let prevRow = prevColIndex == card[0].lastIndex() ? card[rowIndex - 1] : card[rowIndex]
        
        guard rowIndex < card.lastIndex() else {
            var newCard = card
            guard var row = self.card.last, let slot = row[colIndex].claim(previousSlot: prevRow[prevColIndex]) else {
                return nil
            }
            row[colIndex] = slot.stamp()
            newCard[rowIndex] = row
            return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: nextToStamp, numberOfRows: self.numberOfRows, numberOfColumns: self.numberOfColumns, numberOfStampsBeforeReward: self.numberOfStampsBeforeReward)
        }
        var newCard = card
        var row = card[rowIndex]
        guard let slot = row[colIndex].claim(previousSlot: prevRow[prevColIndex]) else {
            return nil
        }
        var nextToStamp = self.nextToStamp
        
        if nextToStamp.row == rowIndex {
            nextToStamp = (row: nextToStamp.row + 1, col: 0)
        }
        
        row[colIndex] = slot.stamp()
        newCard[rowIndex] = row
        
        return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: nextToStamp, numberOfRows: self.numberOfRows, numberOfColumns: self.numberOfColumns, numberOfStampsBeforeReward: self.numberOfStampsBeforeReward)
    }
    
    func allSlotsAreClaimed() -> Bool {
        self.card.first(where: {
            let rewardSlot = $0.first(where: { $0.hasIcon })
            guard let rewardSlot = rewardSlot else {
                return false
            }
            return !rewardSlot.claimed
        }) == nil
    }
    
    static func == (lhs: CardData, rhs: CardData) -> Bool {
        lhs.storeId == rhs.storeId
    }
}
