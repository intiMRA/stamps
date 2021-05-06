//
//  Color+Custom.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 4/05/21.
//

import Foundation
import SwiftUI

public extension Color {
    static var customPurple: Color {
        Color("Purple")
    }
    
    static var customPink: Color {
        Color("Pink")
    }
    
    static var textColor: Color {
        Color("TextColor")
    }
}

extension UIColor {
    static var customPurple: UIColor {
        UIColor(named: "Purple") ?? .black
    }
    
    static var customPink: UIColor {
        UIColor(named: "Pink") ?? .black
    }
    
    static var textColor: UIColor {
        UIColor(named: "TextColor") ?? .black
    }
}
