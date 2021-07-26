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
            VStack(alignment: .leading) {
                HStack {
                    Icon(.logout)
                    Text("Log Out")
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 1, perform: viewModel.logOut)
                NavigationLink(destination: LogInView(), isActive: $viewModel.isLoggedOut) {
                    EmptyView()
                }
                .transition(.slide)
                
                HStack {
                    Icon(.logout)
                    Text("Lol")
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 1, perform: {viewModel.showCardCustomisation = true})
                NavigationLink(destination: CardCustomisationView(), isActive: $viewModel.showCardCustomisation) {
                    EmptyView()
                }
                .transition(.slide)
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .alert(isPresented: $viewModel.shouldShowAlert) {
            Alert(
                title: Text("We are sorry"),
                message: Text("We could not log you out, please try again."),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
