//
//  Store.swift
//  Stamps
//
//  Created by Inti Albuquerque on 15/05/21.
//
import UIKit
import Foundation
struct Store {
    let storeName: String
    let QRCode: UIImage
    let products = [String]()
    init(storeName: String = "The Store") {
        self.storeName = storeName
        self.QRCode = QRCodeManager.generateQRCode(from: storeName)
    }
}
