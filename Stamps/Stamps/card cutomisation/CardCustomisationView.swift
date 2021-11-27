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
        ZStack(alignment: .topLeading) {
            Color.background
            VStack(alignment: .leading) {
                Text("NumberOfRows".localized)
                    .bold()
                    .padding(edges: .bottom, padding: .Xxxsmall)
                CustomTextField(placeholder: viewModel.numberOfRows, text: $viewModel.numberOfRows, keyboardType: .numberPad)
                    .padding(edges: .bottom, padding: .medium)
                
                Text("NumberOfColumns".localized)
                    .bold()
                    .padding(edges: .bottom, padding: .Xxxsmall)
                CustomTextField(placeholder: viewModel.numberOfCols, text: $viewModel.numberOfCols, keyboardType: .numberPad)
                    .padding(edges: .bottom, padding: .medium)
                
                Text("NumberOfStampsBeforeReward".localized)
                    .bold()
                    .padding(edges: .bottom, padding: .Xxxsmall)
                CustomTextField(placeholder: viewModel.rewardsAfterNumber, text: $viewModel.rewardsAfterNumber, keyboardType: .numberPad)
                    .padding(edges: .bottom, padding: .medium)
                
                VStack(alignment: .center) {
                    NavigationLink(
                        destination: CardView(viewModel: CardViewModel(cardData: CardData.newCard(storeName: viewModel.storeName, storeId: viewModel.storeId, listIndex: 0, firstIsStamped: false, numberOfRows: viewModel.numberOfRowsInt, numberOfColumns: viewModel.numberOfColsInt, numberOfStampsBeforeReward: viewModel.rewardsAfterNumberInt), showSubmitButton: true)),
                        isActive: $viewModel.navigateToCreateView,
                        label: {
                            EmptyView()
                        })
                    CustomButton(title: "Preview".localized, action: { viewModel.navigateToCreateView = true })
                    .padding(edges: .bottom, padding: .Xxsmall)
                    
                    CustomButton(title: "Submit".localized, action: viewModel.submit)
                    .padding(edges: .bottom, padding: .Xxsmall)
                    
                    NavigationLink(destination: ShopTabView(storeId: viewModel.storeId), isActive: $viewModel.navigateToTabsView) {
                        EmptyView()
                    }
                }
                .padding(edges: .top, padding: .medium)
                .frame(maxWidth: .infinity)
            }
            .padding(edges: .horizontal, padding: .small)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertContent?.title ?? ""),
                    message: Text(viewModel.alertContent?.message ?? ""),
                    dismissButton: .cancel(Text("Ok".localized), action: {
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
