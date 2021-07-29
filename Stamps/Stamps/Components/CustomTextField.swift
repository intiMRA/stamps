//
//  CustomTextField.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 6/05/21.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> Void = { }
    let secureEntry: Bool
    let keyboardType: UIKeyboardType
    
    init(placeholder: String = "", text: Binding<String>, secureEntry: Bool = false, keyboardType: UIKeyboardType = .alphabet) {
        self.placeholder = placeholder
        self._text = text
        self.secureEntry = secureEntry
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .padding(.leading, 10)
                    .foregroundColor(Color.textColor)
                    .opacity(0.7)
            }
            
            if secureEntry {
                SecureField("", text: $text, onCommit: commit)
                    .keyboardType(keyboardType)
                    .padding(.leading, 10)
            } else {
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                    .keyboardType(keyboardType)
                    .padding(.leading, 10)
            }
        }
        .frame(height: 24)
        .background(Color.white.opacity(0.3))
        .accentColor(Color.textColor)
        .foregroundColor(Color.textColor)
        .cornerRadius(5)
        
    }
}
