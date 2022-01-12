//
//  CardListViewModel.swift
//  Stamps
//
//  Created by Inti Albuquerque on 16/05/21.
//

import Foundation
import Combine

class CardListViewModel: ObservableObject {
    @Published var cardsList = [CardData]()
    
    func cardData(for cardName: String) -> CardData? {
        cardsList.first { $0.storeName == cardName }
    }
    
    func loadData() {
        self.cardsList = ReduxStore.shared.customerModel?.stampCards ?? []
    }
    
}
