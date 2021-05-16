//
//  CardListview.swift
//  Stamps
//
//  Created by Inti Albuquerque on 16/05/21.
//

import SwiftUI

struct CardListview: View {
    @ObservedObject var viewModel = CardListViewModel()
    var body: some View {
        ZStack {
            Color.customPink
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.storeList, id: \.storeName) { store in
                        if let cardData = viewModel.cardData(for: store.storeName) {
                            NavigationLink(destination: CardView(viewModel: CardViewModel(cardData: cardData))) {
                                HStack {
                                    Text(store.storeName)
                                    Spacer()
                                    Image("Chevron")
                                }
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .background(Color.customPink)
        }
    }
}

struct CardListview_Previews: PreviewProvider {
    static var previews: some View {
        CardListview()
    }
}
