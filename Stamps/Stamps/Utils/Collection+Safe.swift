//
//  Collection+Safe.swift
//  Stamps
//
//  Created by Inti Albuquerque on 5/09/21.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
