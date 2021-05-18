//
//  ScanningView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import SwiftUI
struct ScanningView: View {
    @ObservedObject var viewModel = ScanningViewModel()
        
        var body: some View {
            QRCodeScanningViewSwiftUI(code: $viewModel.code, shouldScan: viewModel.shouldScan)
                .onTapGesture(count: 1, perform: { viewModel.shouldScan = true })
        }
}

struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView()
    }
}
