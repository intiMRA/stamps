//
//  ReduxStore.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/05/21.
//

import Foundation

struct customerModel {
    var username = ""
    var stores = [Store]()
    var stampCards = [String: CardData]()
}

class ReduxStore {
    static var shared = ReduxStore()
    
    var customerModel: customerModel?
    var storeModel: Store?
    
}

