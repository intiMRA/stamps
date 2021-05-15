//
//  QRCodeManager.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 7/05/21.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

class QRCodeManager {
    static func generateQRCode(from string: String) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        let data = string.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let CIQrImage = filter.outputImage {
            let context = CIContext()
            if let cgiQrImage = context.createCGImage(CIQrImage, from: CIQrImage.extent) {
                return UIImage(cgImage: cgiQrImage)
            }
        }

        return UIImage()
    }
}
