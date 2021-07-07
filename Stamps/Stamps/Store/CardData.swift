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

struct CardData {
    let card: [[CardSlot]]
    let nextToStamp: (row: Int, col: Int)
    let storeName: String
    let storeId: String
    let listIndex: Int
    let numberOfRows: Int
    let numberOfColums: Int
    let stampsAfter: Int
    
    init(
        card: [[CardSlot]] = [[]],
        storeName: String,
        storeId: String,
        listIndex: Int,
        nextToStamp: (row: Int, col: Int) = (row: 0, col: 0),
        numberOfRows: Int = 5,
        numberOfColums: Int = 4,
        stampsAfter: Int = 4) {
        self.card = card
        self.storeName = storeName
        self.nextToStamp = nextToStamp
        self.listIndex = listIndex
        self.storeId = storeId
        self.numberOfRows = numberOfRows
        self.numberOfColums = numberOfColums
        self.stampsAfter = stampsAfter
    }
    
    func stamp() -> CardData {
        guard nextToStamp.row < card.count else {
            //should never happen
            return self
        }
        
        var row = card[nextToStamp.row]
        var newCard = card
        let slot = row[nextToStamp.col]
        row[nextToStamp.col] = slot.stamp()
        newCard[nextToStamp.row] = row
        
        guard nextToStamp.row < card.count - 1 else {

            guard nextToStamp.col + 2 < row.count else {
                //TODO tell customer to claim rewards
                return self
            }
            return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextToStamp.row, col: nextToStamp.col + 1))
        }
        
        guard nextToStamp.col + 2 < row.count else {
            return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextToStamp.row + 1, col: 0))
        }
        return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: (row: nextToStamp.row, col: nextToStamp.col + 1))
    }
    
    static func newCard(storeName: String, storeId: String, listIndex: Int?, firstStamp: Bool = true, numberOfRows: Int = 5, numberOfColums: Int = 4, stampsAfter: Int = 4) -> CardData {
        var newCard = [[CardSlot]]()
        var amountCreated = 0
        for row in 0 ..< numberOfRows {
            newCard.append([])
            for col in 0 ..< numberOfColums {
                if row == 0, col == 0 {
                    newCard[row].append(CardSlot(isStamped: firstStamp, index: "\(row)_\(col)"))
                    amountCreated += 1
                } else if amountCreated == stampsAfter - 1 {
                    newCard[row].append(CardSlot(isStamped: false, index: "\(row)_\(col)", hasIcon: true))
                    amountCreated = 0
                } else {
                    newCard[row].append(CardSlot(isStamped: false, index: "\(row)_\(col)"))
                    amountCreated += 1
                }
            }
        }
        
        return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex ?? 0, nextToStamp: (row: 0, col: 1))
    }
    
    func claim(index: String) -> CardData? {
        guard
            let rowIndex = Int(String(index.split(separator: "_")[0])),
            Int(index.split(separator: "_")[1]) == card[0].count - 1,
            rowIndex < card.count
        else {
            return self
        }
        
        guard rowIndex < card.count - 1 else {
            var newCard = card
            guard var row = self.card.last, let slot = row[row.count - 1].claim(previousSlot: row[row.count - 2]) else {
                return nil
            }
            row[row.count - 1] = slot.stamp()
            newCard[rowIndex] = row
            return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: nextToStamp)
        }
        var newCard = card
        var row = card[rowIndex]
        guard let slot = row[row.count - 1].claim(previousSlot: row[row.count - 2]) else {
            return nil
        }
        var nextToStamp = self.nextToStamp
        
        if nextToStamp.row == rowIndex {
            nextToStamp = (row: nextToStamp.row + 1, col: 0)
        }
        
        row[row.count - 1] = slot.stamp()
        newCard[rowIndex] = row
        return CardData(card: newCard, storeName: storeName, storeId: storeId, listIndex: listIndex, nextToStamp: nextToStamp)
    }
}
