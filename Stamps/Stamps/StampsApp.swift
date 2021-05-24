//
//  StampsApp.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import SwiftUI
import Firebase

@main
struct StampsApp: App {
    init() {
      FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LogInView()
            }
        }
    }
}
