//
//  CardListview.swift
//  Stamps
//
//  Created by Inti Albuquerque on 16/05/21.
//

import SwiftUI

struct CardListview: View {
    @StateObject var viewModel = CardListViewModel()
    var body: some View {
        ZStack {
            Color.background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if viewModel.cardsList.count == 0 {
                Text("you dont have any cards yet")
                    .foregroundColor(Color.textColor)
                    .padding(.horizontal, 16)
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
                                .padding(.horizontal, 16)
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color.background)
            }
        }
        .onAppear(perform: {
            viewModel.loadData()
        })
    }
}

struct CardListview_Previews: PreviewProvider {
    static var previews: some View {
        CardListview()
    }
}
