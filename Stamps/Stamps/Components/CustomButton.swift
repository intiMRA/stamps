//
//  CustomButton.swift
//  Stamps
//
//  Created by Inti Albuquerque on 23/11/21.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.heavy)
                .foregroundColor(Color.buttonTextColor)
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(edges: .horizontal, padding: .Xxsmall)
            
        }
        .background(Color.customPurple)
        .cornerRadius(3)
    }
}
