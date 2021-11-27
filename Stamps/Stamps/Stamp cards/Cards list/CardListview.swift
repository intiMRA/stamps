//
//  CardListview.swift
//  Stamps
//
//  Created by Inti Albuquerque on 16/05/21.
//

import SwiftUI

struct CardListView: View {
    @StateObject var viewModel = CardListViewModel()
    var body: some View {
        ZStack {
            Color.background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if viewModel.cardsList.count == 0 {
                Text("NoCards".localized)
                    .foregroundColor(Color.textColor)
                    .padding(edges: .horizontal, padding: .small)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.cardsList, id: \.storeId) { cardData in
                            NavigationLink(destination: CardView(viewModel: CardViewModel(cardData: cardData))) {
                                HStack {
                                    Text(cardData.storeName)
                                    Spacer()
                                    Image("Chevron")
                                        .renderingMode(.template)
                                        .foregroundColor(.icon)
                                }
                                .padding(edges: .horizontal, padding: .small)
                                .padding(edges: .bottom, padding: .small)
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color.background)
            }
        }
        .hideNavigationBar()
        .onAppear(perform: {
            viewModel.loadData()
        })
    }
}

struct CardListview_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
