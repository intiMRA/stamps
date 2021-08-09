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
                
                VStack(alignment: .center) {
                    NavigationLink("preview", destination: CardView(viewModel: CardViewModel(cardData: CardData.newCard(storeName: "store", storeId: viewModel.storeId, listIndex: 0, firstIsStamped: false, numberOfRows: viewModel.numberOfRowsInt, numberOfColums: viewModel.numberOfColsInt, numberOfStampsBeforeReward: viewModel.rewardsAfterNumberInt), showSubmitButton: true)))
                        .foregroundColor(Color.textColor)
                        .padding(.bottom, 10)
                    
                        Button("Submit") {
                            viewModel.submit()
                        }
                        .foregroundColor(Color.textColor)
                    
                    NavigationLink(destination: ShopStamp(storeId: viewModel.storeId), isActive: $viewModel.navigateToTabsView) {
                        EmptyView()
                    }
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertContent?.title ?? ""),
                    message: Text(viewModel.alertContent?.message ?? ""),
                    dismissButton: .cancel(Text("Ok"), action: {
                        viewModel.alertContent?.handler()
                        viewModel.alertContent = nil
                    })
                )
            }
        }
    }
}

struct CardCustomisationView_Previews: PreviewProvider {
    static var previews: some View {
        CardCustomisationView(viewModel: CardCustomisationViewModel(storeName: "id", storeId: "id"))
    }
}
