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
        ZStack {
            Color.customPink
        if viewModel.shouldScan {
            QRCodeScanningViewSwiftUI(code: $viewModel.code, shouldScan: viewModel.shouldScan)
        } else {
            VStack {
                Text("Congrats you've a new stamp on your stamp for \(viewModel.code)")
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture(count: 1, perform: { viewModel.shouldScan = true })
        }
    }
    }
}


struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView()
    }
}
