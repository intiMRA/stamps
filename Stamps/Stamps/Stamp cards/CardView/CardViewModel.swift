//
//  CardViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import Foundation
import Combine

class CardViewModel: ObservableObject {
    @Published var stamps: CardData = CardData(storeName: "", storeId: "", listIndex: -1)
    
    init(cardData: CardData) {
        self.stamps = cardData
    }
}
