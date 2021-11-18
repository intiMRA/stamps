//
//  String+Localizable.swift
//  Stamps
//
//  Created by Inti Albuquerque on 21/10/21.
//
import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized, arguments: arguments)
    }
}

