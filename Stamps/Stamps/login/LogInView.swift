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
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        // this only applies to small titles
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        //In the following two lines you make sure that you apply the style for good
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        // This property is not present on the UINavigationBarAppearance
        // object for some reason and you have to leave it til the end
        UINavigationBar.appearance().tintColor = .white
        appearance.backgroundColor = .black
        
    }
    
    @ObservedObject var viewModel: LogInViewModule = LogInViewModule()
    var body: some View {
        ZStack {
            Color.pink
            VStack {
                NavigationLink(destination: CustomerStampView(), isActive: $viewModel.logInSuccess) { EmptyView() }
                
                HStack {
                    Image("email")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    CustomTextField(placeholder: Text("UserName"), text: $viewModel.username, secureEntry: false)
                        .accentColor(.white)
                        .foregroundColor(.white)
                            
                }
                HStack {
                    Image("password")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                    CustomTextField(placeholder: Text("Password"), text: $viewModel.password, secureEntry: true)
                        .foregroundColor(.white)
                        .foregroundColor(.white)
                }
                NavigationLink("Sign Up", destination: SignUpView())
                    .foregroundColor(.white)
                Button("log in") {
                    viewModel.login()
                }
                    .foregroundColor(.white)
                
            }
            .padding()
            .navigationBarTitle("Log In", displayMode: .inline)
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    let secureEntry: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                .foregroundColor(.white)
                    .opacity(0.7)
            }
            
            if secureEntry {
                SecureField("", text: $text, onCommit: commit)
            } else {
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
