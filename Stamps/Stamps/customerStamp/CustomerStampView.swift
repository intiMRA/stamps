//
//  CustomerStampView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 30/04/21.
//

import SwiftUI

struct CustomerStampView: View {
    @ObservedObject private var viewModel: CustomerStampViewModel = CustomerStampViewModel()
    var body: some View {
        ZStack {
            Color.customPink
            VStack {
                CardView(content: viewModel.stamps, completion: { index in
                    viewModel.changed(at: index)
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Stamps", displayMode: .inline)
    }
}

private struct CardView: View {
    let content: CardStamps
    let completion: (_ index: String) -> Void
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
    let content: [IdentifiableBool]
    let completion: (_ index: String) -> Void
    var body: some View {
        HStack(spacing: 10) {
            ForEach(content, id: \.index) { ib in
                CardSlotView(value: ib, completion: completion)
            }
        }
    }
}
private struct CardSlotView: View {
    let value: IdentifiableBool
    let completion: (_ index: String) -> Void
    var body: some View {
        Rectangle()
            .fill(value.value ? Color.customPurple : Color.white)
            .aspectRatio(1.0, contentMode: .fit)
            .cornerRadius(5)
            .onTapGesture(count: 1, perform: { completion(value.index) })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerStampView()
    }
}
