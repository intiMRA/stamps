//
//  ScanningViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import Foundation
import Combine

enum ScanningViewModelState: String {
    case startScreen, scanning, showReward
}

class ScanningViewModel: ObservableObject {
    static var invalidCharacters = CharacterSet(charactersIn: ".#$[]")
    var shouldScan: Bool = false
    @Published var state: ScanningViewModelState = .startScreen
    @Published var code: String = ""
    @Published var storeName = ""
    @Published var shouldShowAlert = false
    var error: ScanningError?
    private var cancellables = Set<AnyCancellable>()
    private let cardApi = StampsAPI()
    
    init() {
        $code
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { code in
                guard !code.isEmpty else {
                    return
                }
                self.foundQRCode(code)
                self.state = .showReward
                self.shouldScan = false
            }
            .store(in: &cancellables)
    }
    
    func foundQRCode(_ code: String) {
        guard code.rangeOfCharacter(from: ScanningViewModel.invalidCharacters) == nil else {
            self.error = ScanningError(title: "Invalid Code", message: "The QR code you scanned is not in our database, or a scanning error occured")
            self.shouldShowAlert = true
            return
        }
        
        if let card = ReduxStore.shared.customerModel?.stampCards.first(where: { $0.storeId == code }) {
            self.storeName = card.storeName
            
            guard let stampedCard = card.stamp() else {
                self.error = ScanningError(title: "Maximum Number Of Stamps", message: "This card has no more slots to be stamped, please claim your rewards")
                self.shouldShowAlert = true
                return
            }
            ReduxStore.shared.changeState(customerModel: ReduxStore.shared.customerModel?.replaceCard(stampedCard))
            cardApi.saveCard(stampedCard)
        } else {
            cardApi.fetchStoreDetails(code: code)
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self.error = error
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
