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
    @Published var showAlert = false
    @Published var navigateToTabsView = false
    
    let storeId: String
    let storeName: String
    
    var numberOfRowsInt = 5
    var numberOfColsInt = 4
    var rewardsAfterNumberInt  = 8
    var alertContent: RewardAlertContent?
    
    var cancellable = Set<AnyCancellable>()
    
    let api: CardCustomizationAPIProtocol
    init(storeName: String? = nil, storeId: String? = nil, api: CardCustomizationAPIProtocol = CardCustomizationAPI()) {
        self.api = api
        self.storeId = storeId ?? ReduxStore.shared.storeModel?.storeId ?? ""
        self.storeName = storeName ?? ReduxStore.shared.storeModel?.storeName ?? ""
        $numberOfRows.sink { rows in
            if let rows = Int(rows) {
                self.numberOfRowsInt = rows
            }
        }
        .store(in: &cancellable)
        
        $numberOfCols.sink { cols in
            if let cols = Int(cols) {
                self.numberOfColsInt = cols
            }
        }
        .store(in: &cancellable)
        
        $rewardsAfterNumber.sink { rewards in
            if let rewards = Int(rewards) {
                self.rewardsAfterNumberInt = rewards
            }
        }
        .store(in: &cancellable)
    }
    
    func submit() {
        api.uploadNewCardDetails(numberOfRows: numberOfRowsInt, numberOfColumns: numberOfColsInt, numberBeforeReward: rewardsAfterNumberInt, storeId: storeId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.alertContent = RewardAlertContent(title: error.title, message: error.message, handler: {
                        self.showAlert = false
                    })
                    self.showAlert = true
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.alertContent = RewardAlertContent(title: "Updated".localized, message: "CardDetailsUpdated".localized, handler: {
                    self.showAlert = false
                    self.navigateToTabsView = true
                })
                self.showAlert = true
            })
            .store(in: &cancellable)
    }
}
