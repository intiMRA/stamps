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
            
            switch viewModel.state {
            case .startScreen:
                VStack {
                    Text("Congrats you've a new stamp on your stamp for \(viewModel.storeName)")
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture(count: 1, perform: {
                    viewModel.state = .scanning
                    viewModel.shouldScan = true
                    
                })
            case .scanning:
                QRCodeScanningViewSwiftUI(code: $viewModel.code, shouldScan: viewModel.shouldScan)
            case .showReward:
                VStack {
                    Text("Congrats you've a new stamp on your stamp for \(viewModel.storeName)")
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture(count: 1, perform: {
                    viewModel.state = .scanning
                    viewModel.shouldScan = true
                    
                })
            }
            
        }
        .alert(isPresented: $viewModel.shouldShowAlert) {
            Alert(
                title: Text(viewModel.error?.title ?? ""),
                message: Text(viewModel.error?.message ?? ""),
                dismissButton: .cancel(Text("Ok"), action: {
                    viewModel.error = nil
                })
            )
        }
    }
}


struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView()
    }
}
