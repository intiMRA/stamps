//
//  TabBarView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import SwiftUI

struct UserTabView: View {
    @State private var selection = 0
    init() {
        UITabBar.appearance().barTintColor = .background
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CardListView()
                .tabItem {
                    VStack {
                        Image(iconName: .list)
                            .renderingMode(.template)
                        Text("YourCards".localized)
                    }
                }
                .tag(0)
            
            ScanningView()
                .tabItem {
                    VStack {
                        Image(iconName: .qrCode)
                            .renderingMode(.template)
                        Text("Scan".localized)
                    }
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(iconName: .settings)
                            .renderingMode(.template)
                        Text("Settings".localized)
                    }
                }
                .tag(2)
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(.textColor)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
    }
}
