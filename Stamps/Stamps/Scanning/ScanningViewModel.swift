//
//  ScanningViewModel.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import Foundation

class ScanningViewModel: ObservableObject {
    
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "Qr-code goes here"
    
    
    func onFoundQrCode(_ code: String) {
        if let card = ReduxStore.shared.customerModel?.stampCards[code] {
            ReduxStore.shared.customerModel?.stampCards[code] = card.stamp()
        } else {
            let row1 = [CardSlot(isStamped: true, index: "\(RowIndex.one.rawValue)_0"),
                        CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_1"),
                        CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_2"),
                        CardSlot(isStamped: false, index: "\(RowIndex.one.rawValue)_3", hasIcon: true)]
            
            let row2 = [CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_0"),
                        CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_1"),
                        CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_2"),
                        CardSlot(isStamped: false, index: "\(RowIndex.two.rawValue)_3", hasIcon: true)]
            
            let row3 = [CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_0"),
                        CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_1"),
                        CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_2"),
                        CardSlot(isStamped: false, index: "\(RowIndex.three.rawValue)_3", hasIcon: true)]
            
            let row4 = [CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_0"),
                        CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_1"),
                        CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_2"),
                        CardSlot(isStamped: false, index: "\(RowIndex.four.rawValue)_3", hasIcon: true)]
            
            let row5 = [CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_0"),
                        CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_1"),
                        CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_2"),
                        CardSlot(isStamped: false, index: "\(RowIndex.five.rawValue)_3", hasIcon: true)]
            ReduxStore.shared.customerModel?.stampCards[code] = CardData(row1: row1, row2: row2, row3: row3, row4: row4, row5: row5)
            ReduxStore.shared.customerModel?.stores = [Store(storeName: code)]
        }
        self.lastQrCode = code
    }
}