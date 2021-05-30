//
//  ScanningViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import Foundation
import Combine

class ScanningViewModel: ObservableObject {
    @Published var shouldScan: Bool = false
    @Published var code: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let cardApi = StampsAPI()
    
    init() {
        $code
            .sink { code in
                self.foundQRCode(code)
                self.shouldScan = false
            }
            .store(in: &cancellables)
    }
    
    func fetchStoreDetails() -> StoreModel? {
        return StoreModel(storeName: "The Store", storeId: "bTvMM0eKsth2n6GMvoawZdlLWV72")
    }
    
    func foundQRCode(_ code: String) {
        guard !code.isEmpty else {
            return
        }
        
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeName == code }) {
            ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(card.stamp()))
            cardApi.saveCard(card)
        } else {
            
            guard let store = fetchStoreDetails() else {
                return
            }
            
            let card = CardData.newCard(storeName: store.storeName, storeId: store.storeId, listIndex: ReduxStore.shared.customerModel?.stampCards.count)
            ReduxStore.shared.addCard(card)
            cardApi.saveCard(card)
        }
    }
}
