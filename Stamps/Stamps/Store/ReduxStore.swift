//
//  ReduxStore.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/05/21.
//

import Foundation
import UIKit
struct CustomerModel: Equatable {
    
    let userId: String
    let username: String
    let stampCards: [CardData]
    
    func replaceCard(_ card: CardData) -> CustomerModel {
        guard let index = stampCards.firstIndex(where: { $0.storeId == card.storeId }) else {
            return self
        }
        var cards = stampCards
        cards[index] = card
        
        return CustomerModel(userId: self.userId, username: self.username, stampCards: cards)
        
    }
    
    static func == (lhs: CustomerModel, rhs: CustomerModel) -> Bool {
        lhs.userId == rhs.userId
    }
}

struct StoreModel: Equatable {
    let storeName: String
    let storeId: String
    let QRCode: UIImage
    let products: [String] = []
    init(storeName: String, storeId: String) {
        self.storeName = storeName
        self.storeId = storeId
        self.QRCode = QRCodeManager.generateQRCode(from: storeId)
    }
    
    static func == (lhs: StoreModel, rhs: StoreModel) -> Bool {
        lhs.storeId == rhs.storeId
    }
}

class ReduxStore {
    private(set) static var shared = ReduxStore()
    
    var customerModel: CustomerModel?
    let storeModel: StoreModel?
    
    init(customerModel: CustomerModel? = nil, storeModel: StoreModel? = nil) {
        self.customerModel = customerModel
        self.storeModel = storeModel
    }
    
    func changeState(customerModel: CustomerModel? = nil, storeModel: StoreModel? = nil) {
        if customerModel == nil && storeModel == nil {
            return
        }
        ReduxStore.shared = ReduxStore(customerModel: customerModel ?? ReduxStore.shared.customerModel, storeModel: storeModel ?? ReduxStore.shared.storeModel)
    }
    
    func addCard(_ card: CardData) {
        guard let customerModel = self.customerModel else {
            return
        }
        var cards = customerModel.stampCards
        cards.append(card)
        ReduxStore.shared.changeState(customerModel: CustomerModel(userId: customerModel.userId, username: customerModel.username, stampCards: cards))
    }
    
}

