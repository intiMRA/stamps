//
//  CardViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine

class CardViewModel: ObservableObject {
    @Published var stamps: CardData = CardData()
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
    
    init(cardData: CardData = CardData(row1: [], row2: [], row3: [], row4: [], row5: [], storeName: "The Store")) {
        self.stamps = CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5)
    }
    
    func changed(at index: String) {
        stamps = stamps.changeAtIndex(at: index)
    }
}
