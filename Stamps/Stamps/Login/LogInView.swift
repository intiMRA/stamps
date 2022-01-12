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
        appearance.backgroundColor = .background
        
    }
    
    @StateObject var viewModel: LogInViewModel = LogInViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.state {
            case .loading:
                Color.background
            case .store:
                ShopTabView(storeId: viewModel.id)
            case .user:
                UserTabView()
            case .notLoggedIn:
                noLoggedInView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var noLoggedInView: some View {
        ZStack {
            Color.background
            VStack(spacing: 10) {
                NavigationLink(destination: nextView, isActive: $viewModel.logInSuccess) { EmptyView() }
                NavigationLink(destination: SignUpView(), isActive: $viewModel.navigateToSignUp) { EmptyView() }
                
                HStack(spacing: 10) {
                    Icon(.email)
                    CustomTextField(placeholder: "Email".localized, text: $viewModel.email, secureEntry: false, keyboardType: .emailAddress)
                }
                HStack {
                    Icon(.password)
                    CustomTextField(placeholder: "Password".localized, text: $viewModel.password, secureEntry: true)
                }
                
                HStack {
                    Icon(.shop)
                    Toggle("SingUpAsAStore".localized, isOn: $viewModel.isStore)
                        .toggleStyle(SwitchToggleStyle(tint: .toggle))
                }
                .padding(edges: .bottom, padding: .Xxsmall)
                
                CustomButton(title: "SignUp".localized, action: { viewModel.navigateToSignUp = true })
                
                CustomButton(title: "logIn".localized, action: viewModel.login)
                
            }
            .padding()
            .navigationBarTitle("LogIn".localized, displayMode: .inline)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.error?.title ?? ""),
                message: Text(viewModel.error?.message ?? ""),
                dismissButton: .cancel(Text("Ok".localized), action: {
                    viewModel.error = nil
                })
            )
        }
    }
    
    @ViewBuilder
    var nextView: some View {
        if viewModel.isStore {
            ShopTabView(storeId: viewModel.id)
        } else {
            UserTabView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
