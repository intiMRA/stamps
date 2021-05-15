//
//  SignUpView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 3/05/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject private var viewModel: SignUpViewModel = SignUpViewModel()
    var body: some View {
        ZStack {
            Color.customPink
            VStack(spacing: 10) {
                NavigationLink(destination: nextView, isActive: $viewModel.signUpSuccessfully) { EmptyView() }
                
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
                HStack {
                    Image("shop")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Toggle("sing up as a store", isOn: $viewModel.isStore)
                }
                
                Button("Submit") {
                    viewModel.signUp()
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
            ShopStamp(username: viewModel.username)
        } else {
            TabBarView()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
