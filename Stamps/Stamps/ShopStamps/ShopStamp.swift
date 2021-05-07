//
//  ShopStamp.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 7/05/21.
//

import SwiftUI

struct ShopStamp: View {
    let username: String
    var body: some View {
        Image(uiImage: QRCodeManager.generateQRCode(from: username))
            .interpolation(.none)
            .resizable()
            .frame(width: 200, height: 200, alignment: .center)
    }
}

struct ShopStamp_Previews: PreviewProvider {
    static var previews: some View {
        ShopStamp(username: "that")
    }
}
