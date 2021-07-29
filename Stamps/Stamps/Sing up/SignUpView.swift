//
//  SignUpView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 3/05/21.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel = SignUpViewModel()
    var body: some View {
        ZStack {
            Color.background
            VStack(spacing: 10) {
                NavigationLink(destination: nextView, isActive: $viewModel.signUpSuccessfully) { EmptyView() }
                
                HStack(spacing: 10) {
                    Icon(.email)
                    CustomTextField(placeholder: "UserName", text: $viewModel.name, secureEntry: false)
                }
                HStack {
                    Icon(.password)
                    CustomTextField(placeholder: "Password", text: $viewModel.password, secureEntry: true)
                }
                HStack {
                    Icon(.shop)
                    Toggle("sing up as a store", isOn: $viewModel.isStore)
                        .toggleStyle(SwitchToggleStyle(tint: .toggle))
                }
                
                Button("Submit") {
                    viewModel.signUp()
                }
                .foregroundColor(Color.textColor)
                
            }
            .padding()
            .navigationBarTitle("Log In", displayMode: .inline)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.error?.title ?? ""),
                message: Text(viewModel.error?.message ?? ""),
                dismissButton: .cancel(Text("Ok"), action: {
                    viewModel.error = nil
                })
            )
        }
    }
    
    @ViewBuilder
    var nextView: some View {
        if viewModel.isStore {
            ShopStamp(storeId: viewModel.id)
        } else {
            UserTabView()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
