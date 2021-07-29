//
//  CardView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import SwiftUI

struct CardView: View {
    @StateObject private var viewModel: CardViewModel
    
    init(viewModel: CardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.background
            VStack {
                Card(content: viewModel.stamps, completion: { slot in
                    if slot.hasIcon, !slot.claimed {
                        viewModel.claim(slot.index)
                    }
                })
                if viewModel.showSubmitButton {
                    Button("Submit") {
                        viewModel.submit()
                    }
                    .foregroundColor(Color.textColor)
                    .padding()
                }
                
                NavigationLink(destination: ShopStamp(storeId: viewModel.stamps.storeId), isActive: $viewModel.navigateToTabsView) {
                    EmptyView()
                }
            }
        }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation( viewModel.showLinearAnimation ? .linear(duration: 0.25) : .easeInOut(duration: 0.25))
        .navigationBarTitle("Stamps", displayMode: .inline)
    }
}

private struct Card: View {
    let content: CardData
    let completion: (_ index: CardSlot) -> Void
    var body: some View {
        ScrollView() {
            VStack(spacing: 50) {
                ForEach(0 ..< content.card.count, id: \.self) { index in
                    HorizontalCardStackView(content: content.card[index], completion: completion)
                }
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
                    Icon(.tick, size: 40)
                } else {
                    Icon(.coffee, size: 40)
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
