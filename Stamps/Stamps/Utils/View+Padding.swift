//
//  View+Padding.swift
//  Stamps
//
//  Created by Inti Albuquerque on 18/11/21.
//

import Foundation
import SwiftUI

enum Padding: CGFloat {
    case empty = 0
    case Xxxsmall = 4
    case Xxsmall = 8
    case Xsmall = 12
    case small = 16
    case medium = 20
    case large = 24
    case XLarge = 40
}

extension View {
    func padding(edges: Edge.Set, padding: Padding) -> some View {
        self.padding(edges, padding.rawValue)
    }
    
    func standardPadding() -> some View {
        self.padding(edges: .horizontal, padding: .Xsmall)
    }
}
