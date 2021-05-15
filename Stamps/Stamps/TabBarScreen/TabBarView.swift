//
//  TabBarView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CustomerStampView()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image("Grid")
                    Text("Grid")
                }
            
            ScanningView()
                .tabItem {
                    Image("QR")
                    Text("Scan")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
