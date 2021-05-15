//
//  ReduxStore.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/05/21.
//

import Foundation

class ReduxStore {
    static var shared = ReduxStore()
    
    var username = ""
    var isStore = false
    var stores = [Store]()
    var stanpCards = [String: CardData]()
}

