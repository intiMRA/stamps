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
    
    static var background: Color {
        Color("Background")
    }
    
    static var icon: Color {
        Color("IconColor")
    }
    
    static var toggle: Color {
        Color("ToggleColor")
    }
    
    static var customPink: Color {
        Color("Pink")
    }
    
    static var textColor: Color {
        Color("TextColor")
    }
    
    static var buttonTextColor: Color {
        Color("ButtonTextColor")
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
    
    static var background: UIColor {
        UIColor(named: "Background") ?? .black
    }
    
    static var icon: UIColor {
        UIColor(named: "IconColor") ?? .black
    }
    
    static var buttonTextColor: UIColor {
        UIColor(named: "ButtonTextColor") ?? .black
    }
}
