//
//  CardView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import SwiftUI

struct CardView: View {
    @ObservedObject private var viewModel: CardViewModel
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.customPink
            VStack {
                Card(content: viewModel.stamps, completion: { slot in
                    if slot.hasIcon {
                        viewModel.claim(slot.index)
                    }
                })
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertContent?.title ?? ""),
                message: Text(viewModel.alertContent?.message ?? ""),
                dismissButton: .cancel(Text("Ok"), action: {
                    viewModel.alertContent = nil
                })
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Stamps", displayMode: .inline)
    }
}

private struct Card: View {
    let content: CardData
    let completion: (_ index: CardSlot) -> Void
    var body: some View {
        ScrollView() {
            VStack(spacing: 50) {
                HorizontalCardStackView(content: content.row1, completion: completion)
                HorizontalCardStackView(content: content.row2, completion: completion)
                HorizontalCardStackView(content: content.row3, completion: completion)
                HorizontalCardStackView(content: content.row4, completion: completion)
                HorizontalCardStackView(content: content.row5, completion: completion)
            }
            .padding(.all, 10)
        }
        .background(Color.white.opacity(0.2))
        .padding()
        .cornerRadius(5)
    }
}
private struct HorizontalCardStackView: View {
    let content: [CardSlot]
    let completion: (_ index: CardSlot) -> Void
    var body: some View {
        HStack(spacing: 10) {
            ForEach(content, id: \.index) { ib in
                CardSlotView(value: ib, completion: completion)
            }
        }
    }
}
private struct CardSlotView: View {
    let value: CardSlot
    let completion: (_ index: CardSlot) -> Void
    var body: some View {
        ZStack {
            Rectangle()
                .fill(value.isStamped ? Color.customPurple : Color.white)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(5)
                .onTapGesture(count: 1, perform: { completion(value) })
            if value.hasIcon {
                if value.isStamped && value.claimed {
                    Image("tick")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                } else {
                    Image("coffee")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                }
            }
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(viewModel: CardViewModel(cardData: CardData(storeName: "", storeId: "", listIndex: -1)))
    }
}
