//
//  ContentView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import SwiftUI

struct LogInView: View {
    init() {
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance()
        
        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()
        
        // this only applies to big titles
        appearance.largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.textColor
        ]
        // this only applies to small titles
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.textColor
        ]
        
        //In the following two lines you make sure that you apply the style for good
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        // This property is not present on the UINavigationBarAppearance
        // object for some reason and you have to leave it til the end
        UINavigationBar.appearance().tintColor = .textColor
        appearance.backgroundColor = .customPink
        
    }
    
    @ObservedObject var viewModel: LogInViewModule = LogInViewModule()
    var body: some View {
        ZStack {
            Color.customPink
            VStack(spacing: 10) {
                NavigationLink(destination: nextView, isActive: $viewModel.logInSuccess) { EmptyView() }
                
                HStack(spacing: 10) {
                    Image("email")
                        .resizable()
                        .frame(width: 24, height: 24)
                    CustomTextField(placeholder: Text("UserName"), text: $viewModel.username, secureEntry: false)                            
                }
                HStack {
                    Image("password")
                        .resizable()
                        .frame(width: 24, height: 24)
                    CustomTextField(placeholder: Text("Password"), text: $viewModel.password, secureEntry: true)
                }
                NavigationLink("Sign Up", destination: SignUpView())
                    .foregroundColor(Color.textColor)
                Button("log in") {
                    viewModel.login()
                }
                .foregroundColor(Color.textColor)
                
            }
            .padding()
            .navigationBarTitle("Log In", displayMode: .inline)
        }
    }
    
    @ViewBuilder
    var nextView: some View {
        if viewModel.isStore {
            ShopStamp(soreId: viewModel.username)
        } else {
            TabBarView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
