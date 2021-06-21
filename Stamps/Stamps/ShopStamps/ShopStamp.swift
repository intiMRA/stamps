//
//  ShopStamp.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 7/05/21.
//

import SwiftUI

struct ShopStamp: View {
    let soreId: String
    var body: some View {
        Image(uiImage: QRCodeManager.generateQRCode(from: soreId))
            .interpolation(.none)
            .resizable()
            .frame(width: 200, height: 200, alignment: .center)
            .navigationBarBackButtonHidden(true)
    }
}

struct ShopStamp_Previews: PreviewProvider {
    static var previews: some View {
        ShopStamp(soreId: "that")
    }
}
