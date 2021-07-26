//
//  CardCustomisationViewModel.swift
//  Stamps
//
//  Created by Inti Albuquerque on 19/07/21.
//

import Foundation
import Combine

class CardCustomisationViewModel: ObservableObject {
    @Published var numberOfRows = "5"
    @Published var numberOfCols = "4"
    @Published var rewardsAfterNumber = "8"
    
    let storeId: String
    let storeName: String
    
    var numberOfRowsInt = 5
    var numberOfColsInt = 4
    var rewardsAfterNumberInt  = 8
    
    var cancellables = Set<AnyCancellable>()
    
    let api: CardCustomizationAPI
    init(storeName: String? = nil, storeId: String? = nil, api: CardCustomizationAPI = CardCustomizationAPI()) {
        self.api = api
        self.storeId = storeId ?? ReduxStore.shared.storeModel?.storeId ?? ""
        self.storeName = storeName ?? ReduxStore.shared.storeModel?.storeName ?? ""
        $numberOfRows.sink { rows in
            if let rows = Int(rows) {
                self.numberOfRowsInt = rows
            }
        }
        .store(in: &cancellables)
        
        $numberOfCols.sink { cols in
            if let cols = Int(cols) {
                self.numberOfColsInt = cols
            }
        }
        .store(in: &cancellables)
        
        $rewardsAfterNumber.sink { rewards in
            if let rewards = Int(rewards) {
                self.rewardsAfterNumberInt = rewards
            }
        }
        .store(in: &cancellables)
    }
    
    func submit() {
        api.uploadNewCardDetails(numberOfRows: numberOfRowsInt, numberOfColumns: numberOfColsInt, numberBeforeReward: rewardsAfterNumberInt, storeId: storeId)
    }
}
