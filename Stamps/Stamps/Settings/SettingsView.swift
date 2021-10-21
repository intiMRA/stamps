//
//  SettingsView.swift
//  Stamps
//
//  Created by Inti Albuquerque on 21/06/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    var body: some View {
        ZStack(alignment: .leading) {
            Color.background
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Icon(.logout)
                    Text("LogOut".localized)
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 1, perform: viewModel.logOut)
                NavigationLink(destination: LogInView(), isActive: $viewModel.isLoggedOut) {
                    EmptyView()
                }
                .transition(.slide)
                
                if viewModel.isStore {
                    HStack {
                        Icon(.customize)
                        Text("CustomiseYourCard".localized)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(count: 1, perform: {viewModel.showCardCustomisation = true})
                    NavigationLink(destination: CardCustomisationView(), isActive: $viewModel.showCardCustomisation) {
                        EmptyView()
                    }
                    .transition(.slide)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .alert(isPresented: $viewModel.shouldShowAlert) {
            Alert(
                title: Text("WeAreSorry".localized),
                message: Text("WeCouldNotLogOut".localized),
                dismissButton: .cancel(Text("Ok".localized))
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
