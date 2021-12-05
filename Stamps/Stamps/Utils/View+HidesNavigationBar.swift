//
//  View+HidesNavigationBar.swift
//  Stamps
//
//  Created by Inti Albuquerque on 27/11/21.
//

import SwiftUI

extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}
