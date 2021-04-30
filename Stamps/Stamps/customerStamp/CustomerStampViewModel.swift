//
//  CustomerStampViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine

struct IdentifiableBool {
    let value: Bool
    let index: String
}
struct CardStamps {
    enum RowIndex: String{
        case one
        case two
        case three
        case four
        case five
    }
    let row1: [IdentifiableBool]
    let row2: [IdentifiableBool]
    let row3: [IdentifiableBool]
    let row4: [IdentifiableBool]
    let row5: [IdentifiableBool]
    
    init(row1: [Bool] = [], row2: [Bool] = [], row3: [Bool] = [], row4: [Bool] = [], row5: [Bool] = []) {
        self.row1 = row1.enumerated().map { IdentifiableBool(value: $0.element, index: "\(RowIndex.one.rawValue)_\($0.offset)") }
        self.row2 = row2.enumerated().map { IdentifiableBool(value: $0.element, index: "\(RowIndex.two.rawValue)_\($0.offset)") }
        self.row3 = row3.enumerated().map { IdentifiableBool(value: $0.element, index: "\(RowIndex.three.rawValue)_\($0.offset)") }
        self.row4 = row4.enumerated().map { IdentifiableBool(value: $0.element, index: "\(RowIndex.four.rawValue)_\($0.offset)") }
        self.row5 = row5.enumerated().map { IdentifiableBool(value: $0.element, index: "\(RowIndex.five.rawValue)_\($0.offset)") }
    }
    
     init(row1: [IdentifiableBool], row2: [IdentifiableBool], row3: [IdentifiableBool], row4: [IdentifiableBool], row5: [IdentifiableBool]) {
        self.row1 = row1
        self.row2 = row2
        self.row3 = row3
        self.row4 = row4
        self.row5 = row5
     }
    
    func changeAtIndex(at index: String) -> CardStamps {
        var changed = [IdentifiableBool]()
        let indexes = index.split(separator: "_")
        guard let row = RowIndex(rawValue: String(indexes[0])), let indexNumber = Int(indexes[1]) else {
            return self
        }
        switch row {
        case .one:
            changed = row1
            changed[indexNumber] = IdentifiableBool(value: true, index: index)
            return CardStamps(row1: changed, row2: row2, row3: row3, row4: row4, row5: row5)
        case .two:
            changed = row2
            changed[indexNumber] = IdentifiableBool(value: true, index: index)
            return CardStamps(row1: row1, row2: changed, row3: row3, row4: row4, row5: row5)
        case .three:
            changed = row3
            changed[indexNumber] = IdentifiableBool(value: true, index: index)
            return CardStamps(row1: row1, row2: row2, row3: changed, row4: row4, row5: row5)
        case .four:
            changed = row4
            changed[indexNumber] = IdentifiableBool(value: true, index: index)
            return CardStamps(row1: row1, row2: row2, row3: row3, row4: changed, row5: row5)
        case .five:
            changed = row5
            changed[indexNumber] = IdentifiableBool(value: true, index: index)
            return CardStamps(row1: row1, row2: row2, row3: row3, row4: row4, row5: changed)
        }
    }
}

class CustomerStampViewModel: ObservableObject {
    @Published var stamps: CardStamps = CardStamps()
    
    init() {
        let row1 = [false, false, false, false]
        let row2 = [false, true, false, false]
        let row3 = [false, false, false, false]
        let row4 = [false, true, false, false]
        let row5 = [false, false, false, false]
        self.stamps = CardStamps(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5)
    }
    
    func changed(at index: String) {
        stamps = stamps.changeAtIndex(at: index)
    }
}
