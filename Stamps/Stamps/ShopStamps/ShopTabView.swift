//
//  ShopStamp.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 7/05/21.
//

import SwiftUI

struct ShopTabView: View {
    let storeId: String
    @State private var selection = 0
    init(storeId: String) {
        self.storeId = storeId
        UITabBar.appearance().isTranslucent = false
    }
    var body: some View {
        ZStack {
            Color.background
            TabView(selection: $selection) {
                ZStack {
                    Color.background
                        .ignoresSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack {
                        Spacer()
                        Image(uiImage: QRCodeManager.generateQRCode(from: storeId))
                            .interpolation(.none)
                            .resizable()
                            .frame(size: 200)
                            .padding(edges: .top, padding: .XLarge)
                            .hideNavigationBar()
                        Spacer()
                        Rectangle()
                            .frame(height: 1)
                            .opacity(0.3)
                    }
                }
                .tabItem {
                    Image(iconName: .qrCode)
                        .renderingMode(.template)
                    Text("YourCards".localized)
                }
                .tag(0)
                ZStack {
                    Color.background
                        .ignoresSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack {
                        SettingsView()
                            .padding(edges: .top, padding: .XLarge)
                        Rectangle()
                            .frame(height: 1)
                            .opacity(0.3)
                    }
                }
                .tabItem {
                    VStack {
                        Image(iconName: .settings)
                            .renderingMode(.template)
                        Text("Settings".localized)
                    }
                }
                .tag(1)
            }
            .accentColor(.textColor)
            .padding(edges: .bottom, padding: .Xxsmall)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ShopStamp_Previews: PreviewProvider {
    static var previews: some View {
        ShopTabView(storeId: "that")
    }
}
