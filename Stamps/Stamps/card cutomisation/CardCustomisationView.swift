//
//  CardCustomisationView.swift
//  Stamps
//
//  Created by Inti Albuquerque on 19/07/21.
//

import SwiftUI

struct CardCustomisationView: View {
    @StateObject var viewModel = CardCustomisationViewModel()
    var body: some View {
        ZStack {
            Color.background
            VStack(alignment: .leading) {
                Text("Nuber of rows in your card")
                CustomTextField(placeholder: viewModel.numberOfRows, text: $viewModel.numberOfRows, secureEntry: false)
                
                Text("Nuber of colums in your card")
                CustomTextField(placeholder: viewModel.numberOfCols, text: $viewModel.numberOfCols, secureEntry: false)
                
                Text("Nuber of stamps required before reward")
                CustomTextField(placeholder: viewModel.rewardsAfterNumber, text: $viewModel.rewardsAfterNumber, secureEntry: false)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct CardCustomisationView_Previews: PreviewProvider {
    static var previews: some View {
        CardCustomisationView()
    }
}
