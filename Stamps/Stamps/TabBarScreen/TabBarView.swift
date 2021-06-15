//
//  TabBarView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 0
    init() {
        UITabBar.appearance().barTintColor = .background
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CardListview()
                .tabItem {
                    VStack {
                        Image("List")
                            .renderingMode(.template)
                        Text("Your Cards")
                    }
                }
                .tag(0)
            
            ScanningView()
                .tabItem {
                    VStack {
                        Image("QR")
                            .renderingMode(.template)
                        Text("Scan")
                    }
                }
                .tag(1)
        }
        .accentColor(.textColor)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
