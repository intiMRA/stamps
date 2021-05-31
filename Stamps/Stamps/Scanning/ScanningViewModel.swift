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
    @Published var storeName = ""
    @Published var shouldShowAlert = false
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
    
    func foundQRCode(_ code: String) {
        guard !code.isEmpty else {
            return
        }
        
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            self.storeName = card.storeName
            let stampedCard = card.stamp()
            ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(stampedCard))
            cardApi.saveCard(stampedCard)
        } else {
            
            cardApi.fetchStoreDetails(code: code)
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self.shouldShowAlert = true
                        break
                    }
                }, receiveValue: { store in
                    self.storeName = store.storeName
                    let card = CardData.newCard(storeName: store.storeName, storeId: store.storeId, listIndex: ReduxStore.shared.customerModel?.stampCards.count)
                    ReduxStore.shared.addCard(card)
                    self.cardApi.saveCard(card)
                })
                .store(in: &cancellables)
        }
    }
}
