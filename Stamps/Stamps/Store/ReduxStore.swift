//
//  ReduxStore.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/05/21.
//

import Foundation
import UIKit

protocol ReduxStoreProtocol {
    var customerModel: CustomerModel? { get }
    var storeModel: StoreModel? { get }
    func changeState(customerModel: CustomerModel?, storeModel: StoreModel?) async
    func addCard(_ card: CardData) async
    
}

extension ReduxStoreProtocol {
    func changeState(customerModel: CustomerModel? = nil, storeModel: StoreModel? = nil) async {
        await changeState(customerModel: customerModel, storeModel: storeModel)
    }
}
struct CustomerModel: Equatable {
    
    let userId: String
    let email: String
    let userName: String
    let stampCards: [CardData]
    
    func replaceCard(_ card: CardData) -> CustomerModel {
        guard let index = stampCards.firstIndex(where: { $0.storeId == card.storeId }) else {
            return self
        }
        var cards = stampCards
        cards[index] = card
        
        return CustomerModel(userId: self.userId, email: self.email, userName: self.userName, stampCards: cards)
    }
    
    static func == (lhs: CustomerModel, rhs: CustomerModel) -> Bool {
        lhs.userId == rhs.userId
    }
}

struct StoreModel: Equatable {
    let storeName: String
    let storeId: String
    let numberOfRows: Int
    let numberOfColumns: Int
    let numberOfStampsBeforeReward: Int
    let QRCode: UIImage
    let products: [String] = []
    init(storeName: String,
         storeId: String,
         numberOfRows: Int = 5,
         numberOfColumns: Int = 4,
         numberOfStampsBeforeReward: Int = 8
    ) {
        self.storeName = storeName
        self.storeId = storeId
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.numberOfStampsBeforeReward = numberOfStampsBeforeReward
        self.QRCode = QRCodeManager.generateQRCode(from: storeId)
    }
    
    static func == (lhs: StoreModel, rhs: StoreModel) -> Bool {
        lhs.storeId == rhs.storeId
    }
}

//TODO: async
actor ReduxStore: ReduxStoreProtocol {
    private(set) static var shared = ReduxStore()
    
    let customerModel: CustomerModel?
    let storeModel: StoreModel?
    
    init(customerModel: CustomerModel? = nil, storeModel: StoreModel? = nil) {
        self.customerModel = customerModel
        self.storeModel = storeModel
    }
    
    func changeState(customerModel: CustomerModel? = nil, storeModel: StoreModel? = nil) async {
        if customerModel == nil && storeModel == nil {
            return
        }
        ReduxStore.shared = ReduxStore(customerModel: customerModel ?? ReduxStore.shared.customerModel, storeModel: storeModel ?? ReduxStore.shared.storeModel)
    }
    
    func addCard(_ card: CardData) async {
        guard let customerModel = self.customerModel else {
            return
        }
        var cards = customerModel.stampCards
        cards.append(card)
        await ReduxStore.shared.changeState(customerModel: CustomerModel(userId: customerModel.userId, email: customerModel.email, userName: customerModel.userName, stampCards: cards))
    }
    
    func setNill() {
        ReduxStore.shared = ReduxStore()
    }
    
}

