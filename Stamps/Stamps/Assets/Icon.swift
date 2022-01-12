//
//  Icon.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/06/21.
//

import SwiftUI

enum IconName: String {
    case logout = "Logout"
    case chevron = "Chevron"
    case coffee = "Coffee"
    case email = "Email"
    case list = "List"
    case password = "Password"
    case qrCode = "Qr-code"
    case shop = "Shop"
    case tick = "Tick"
    case settings = "Settings"
    case customize = "Customize"
    case user = "User"
}

struct Icon: View {
    let name: String
    let alignment: Alignment
    let size: CGFloat
    
    init(_ name: IconName, alignment: Alignment = .center, size: CGFloat = 24) {
        self.name = name.rawValue
        self.alignment = alignment
        self.size = size
    }
    
    var body: some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .frame(size: size, alignment: alignment)
            .foregroundColor(.icon)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(.email)
    }
}

extension View {
    func frame(size: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
}

extension Image {
    init(iconName: IconName) {
        self.init(iconName.rawValue)
    }
}
