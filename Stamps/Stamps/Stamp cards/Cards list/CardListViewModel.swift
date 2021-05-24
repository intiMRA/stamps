//
//  CardListViewModel.swift
//  Stamps
//
//  Created by Inti Albuquerque on 16/05/21.
//

import Foundation
import Combine

class CardListViewModel: ObservableObject {
    @Published var cardsList = [String: CardData]()
    @Published var storeList = [Store]()
    
    init() {
        self.cardsList = ReduxStore.shared.customerModel?.stampCards ?? [:]
        self.storeList = ReduxStore.shared.customerModel?.stores ?? []
    }
    
    func cardData(for cardName: String) -> CardData? {
        cardsList[cardName]
    }
    
    func loadData() {
        self.cardsList = ReduxStore.shared.customerModel?.stampCards ?? [:]
        self.storeList = ReduxStore.shared.customerModel?.stores ?? []
    }
    
}
