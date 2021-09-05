//
//  ScanningView.swift
//  Stamps
//
//  Created by Inti Resende Albuquerque on 11/05/21.
//

import SwiftUI
struct ScanningView: View {
    @StateObject var viewModel = ScanningViewModel()
    
    var body: some View {
        ZStack {
            Color.background
            
            switch viewModel.state {
            case .startScreen:
                VStack {
                    Text("Please tap to scan.")
                        .foregroundColor(Color.textColor)
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture(count: 1, perform: {
                    viewModel.state = .scanning
                    viewModel.shouldScan = true
                    
                })
            case .scanning:
                QRCodeScanningViewSwiftUI(viewModel, shouldScan: viewModel.shouldScan)
            case .showReward:
                VStack {
                    Text("Congrats you've a new stamp on your stamp for \(viewModel.storeName)")
                        .foregroundColor(Color.textColor)
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
