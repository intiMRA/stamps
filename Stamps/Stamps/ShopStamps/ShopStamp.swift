//
//  ShopStamp.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 7/05/21.
//

import SwiftUI

struct ShopStamp: View {
    let storeId: String
    @State private var selection = 0
    init(storeId: String) {
        self.storeId = storeId
        UITabBar.appearance().barTintColor = .background
    }
    var body: some View {
        TabView(selection: $selection) {
            ZStack {
                Color.background
                Image(uiImage: QRCodeManager.generateQRCode(from: storeId))
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
            }
            .tabItem {
                Image(iconName: .qrCode)
                    .renderingMode(.template)
                Text("Your Cards")
            }
            .tag(0)
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(iconName: .settings)
                            .renderingMode(.template)
                        Text("Settings")
                    }
                }
                .tag(1)
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(.textColor)
    }
}

struct ShopStamp_Previews: PreviewProvider {
    static var previews: some View {
        ShopStamp(storeId: "that")
    }
}
