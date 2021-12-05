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
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: viewModel.logOut) {
                        HStack {
                            HStack {
                                Icon(.logout)
                                Text("LogOut".localized)
                            }
                        }
                        Spacer()
                    }
                    
                    NavigationLink(destination: LogInView(), isActive: $viewModel.isLoggedOut) {
                        EmptyView()
                    }
                    .transition(.slide)
                    
                    if viewModel.isStore {
                        Button(action: { viewModel.showCardCustomisation = true }) {
                            HStack {
                                HStack {
                                    Icon(.customize)
                                    Text("CustomiseYourCard".localized)
                                }
                                Spacer()
                            }
                        }
                        
                        NavigationLink(destination: CardCustomisationView(), isActive: $viewModel.showCardCustomisation) {
                            EmptyView()
                        }
                        .transition(.slide)
                    }
                    
                    Spacer()
                }
                .padding(edges: .horizontal, padding: .small)
            }
        }
        .hideNavigationBar()
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
