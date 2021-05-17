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
    
    init(cardData: CardData = CardData(row1: [], row2: [], row3: [], row4: [], row5: [], storeName: "The Store")) {
        self.stamps = cardData
    }
}
