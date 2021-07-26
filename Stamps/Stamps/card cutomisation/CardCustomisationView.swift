//
//  CardCustomisationView.swift
//  Stamps
//
//  Created by Inti Albuquerque on 19/07/21.
//

import SwiftUI

struct CardCustomisationView: View {
    @StateObject var viewModel: CardCustomisationViewModel
    init(viewModel: CardCustomisationViewModel = CardCustomisationViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
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
                NavigationLink("preview", destination: CardView(viewModel: CardViewModel(cardData: CardData.newCard(storeName: "store", storeId: viewModel.storeId, listIndex: 0, firstIsStamped: false, numberOfRows: viewModel.numberOfRowsInt, numberOfColums: viewModel.numberOfColsInt, stampsAfter: viewModel.rewardsAfterNumberInt), showSubmitButton: true)))
                    Button("Submit") {
                        viewModel.submit()
                    }
                    .padding()
            }
            .padding(.horizontal, 16)
        }
    }
}

struct CardCustomisationView_Previews: PreviewProvider {
    static var previews: some View {
        CardCustomisationView(viewModel: CardCustomisationViewModel(storeName: "id", storeId: "id"))
    }
}
