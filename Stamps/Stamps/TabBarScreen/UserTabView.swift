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
                        CardListView()
                            .padding(edges: .top, padding: .large)
                        Rectangle()
                            .frame(height: 1)
                            .opacity(0.3)
                    }
                }
                .tabItem {
                    VStack {
                        Image(iconName: .list)
                            .renderingMode(.template)
                        Text("YourCards".localized)
                    }
                }
                .tag(0)
                ZStack {
                    Color.background
                        .ignoresSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack {
                        ScanningView()
                            .padding(edges: .top, padding: .large)
                        Rectangle()
                            .frame(height: 1)
                            .opacity(0.3)
                    }
                }
                .tabItem {
                    VStack {
                        Image(iconName: .qrCode)
                            .renderingMode(.template)
                        Text("Scan".localized)
                    }
                }
                .tag(1)
                ZStack {
                    Color.background
                        .ignoresSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack {
                        SettingsView()
                            .padding(edges: .top, padding: .large)
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
                .tag(2)
            }
            .accentColor(.textColor)
            .padding(edges: .bottom, padding: .Xxsmall)
        }
        .hideNavigationBar()
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
    }
}
