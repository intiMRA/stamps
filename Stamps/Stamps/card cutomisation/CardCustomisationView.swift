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
                CustomTextField(placeholder: viewModel.numberOfRows, text: $viewModel.numberOfRows, keyboardType: .numberPad)
                
                Text("Nuber of colums in your card")
                CustomTextField(placeholder: viewModel.numberOfCols, text: $viewModel.numberOfCols, keyboardType: .numberPad)
                
                Text("Nuber of stamps required before reward")
                CustomTextField(placeholder: viewModel.rewardsAfterNumber, text: $viewModel.rewardsAfterNumber, keyboardType: .numberPad)
                NavigationLink("preview", destination: CardView(viewModel: CardViewModel(cardData: CardData.newCard(storeName: "store", storeId: "id", listIndex: 0, firstIsStamped: false, numberOfRows: viewModel.numberOfRowsInt, numberOfColums: viewModel.numberOfColsInt, stampsAfter: viewModel.rewardsAfterNumberInt), api: nil)))
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
