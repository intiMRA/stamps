//
//  CustomerStampViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine

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

struct CardStamps {
    let row1: [CardSlot]
    let row2: [CardSlot]
    let row3: [CardSlot]
    let row4: [CardSlot]
    let row5: [CardSlot]
    
    init(row1: [CardSlot] = [], row2: [CardSlot] = [], row3: [CardSlot] = [], row4: [CardSlot] = [], row5: [CardSlot] = []) {
        self.row1 = row1
        self.row2 = row2
        self.row3 = row3
        self.row4 = row4
        self.row5 = row5
    }
    
    func changeAtIndex(at index: String) -> CardStamps {
        var changed = [CardSlot]()
        let indexes = index.split(separator: "_")
        guard let row = RowIndex(rawValue: String(indexes[0])), let indexNumber = Int(indexes[1]) else {
            return self
        }
        switch row {
        case .one:
            changed = row1
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            return CardStamps(row1: changed, row2: row2, row3: row3, row4: row4, row5: row5)
        case .two:
            changed = row2
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            return CardStamps(row1: row1, row2: changed, row3: row3, row4: row4, row5: row5)
        case .three:
            changed = row3
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            return CardStamps(row1: row1, row2: row2, row3: changed, row4: row4, row5: row5)
        case .four:
            changed = row4
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            return CardStamps(row1: row1, row2: row2, row3: row3, row4: changed, row5: row5)
        case .five:
            changed = row5
            changed[indexNumber] = CardSlot(isStamped: true, index: index, hasIcon: changed[indexNumber].hasIcon)
            return CardStamps(row1: row1, row2: row2, row3: row3, row4: row4, row5: changed)
        }
    }
}

class CustomerStampViewModel: ObservableObject {
    @Published var stamps: CardStamps = CardStamps()
    
    init() {
        let row1 = [CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_0"),
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
        
        self.stamps = CardStamps(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5)
    }
    
    func changed(at index: String) {
        stamps = stamps.changeAtIndex(at: index)
    }
}
