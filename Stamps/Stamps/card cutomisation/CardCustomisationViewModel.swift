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
}
