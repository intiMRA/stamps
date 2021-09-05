//
//  Collection+LastIndex.swift
//  Stamps
//
//  Created by Inti Albuquerque on 5/09/21.
//

import Foundation

extension Collection {
    func lastIndex() -> Int {
        Swift.max(count - 1, 0)
    }
}
