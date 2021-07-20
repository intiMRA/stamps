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
    
    var numberOfRowsInt = 5
    var numberOfColsInt = 4
    var rewardsAfterNumberInt  = 8
    
    var c = Set<AnyCancellable>()
    
    init() {
        $numberOfRows.sink { rows in
            if let rows = Int(rows) {
                self.numberOfRowsInt = rows
            }
        }
        .store(in: &c)
        
        $numberOfCols.sink { cols in
            if let cols = Int(cols) {
                self.numberOfColsInt = cols
            }
        }
        .store(in: &c)
        
        $rewardsAfterNumber.sink { rewards in
            if let rewards = Int(rewards) {
                self.rewardsAfterNumberInt = rewards
            }
        }
        .store(in: &c)
    }
}
