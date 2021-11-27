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
            case .showStartState:
                VStack {
                    Text("PleaseTapToScan".localized)
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
                        Text("Congrats".localizeWithFormat(arguments: viewModel.storeName))
                            .foregroundColor(Color.textColor)
                    }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture(count: 1, perform: {
                        viewModel.state = .scanning
                        viewModel.shouldScan = true
                        
                    })
            case .blankScreen:
                EmptyView()
            case .showStampAnimation:
                LottieView(name: .done, completion: { _ in viewModel.state = .showStartState })
                    .frame(size: 200)
            case .showRewardAnimation:
                LottieView(name: .heart, completion: { _ in viewModel.state = .showReward })
                    .frame(size: 200)
            }
            
        }
        .hideNavigationBar()
        .onAppear(perform: viewModel.startingState)
        .alert(isPresented: $viewModel.shouldShowAlert) {
            Alert(
                title: Text(viewModel.error?.title ?? ""),
                message: Text(viewModel.error?.message ?? ""),
                dismissButton: .cancel(Text("Ok".localized), action: {
                    viewModel.error = nil
                    viewModel.state = .showStartState
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
