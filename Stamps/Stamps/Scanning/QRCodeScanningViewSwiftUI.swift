//
//  QRCodeScanningViewSwiftUI.swift
//  Stamps
//
//  Created by Inti Albuquerque on 18/05/21.
//
import SwiftUI

struct QRCodeScanningViewSwiftUI: UIViewRepresentable {
    
    @StateObject var viewModel: ScanningViewModel
    let shouldScan: Bool
    
    init(_ viewModel: ScanningViewModel, shouldScan: Bool) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.shouldScan = shouldScan
    }
    
    func makeUIView(context: UIViewRepresentableContext<QRCodeScanningViewSwiftUI>) -> QRCodeScanningView {
        let qrCodeView = QRCodeScanningView()
        qrCodeView.delegate = context.coordinator
        return qrCodeView
    }
    
    func updateUIView(_ uiView: QRCodeScanningView, context: UIViewRepresentableContext<QRCodeScanningViewSwiftUI>) {
        if shouldScan {
            uiView.startScanning()
        } else {
            uiView.stopScanning()
        }
    }
    
    func makeCoordinator() -> QRCodeScanningViewSwiftUI.Coordinator {
        Coordinator(parent: self)
    }
    
    static func dismantleUIView(_ uiView: QRCodeScanningView, coordinator: Self.Coordinator) {
        uiView.stopScanning()
    }
    
    class Coordinator: NSObject, QRCodeScanningViewDelegate {
        var parent: QRCodeScanningViewSwiftUI
        init(parent: QRCodeScanningViewSwiftUI) {
            self.parent = parent
        }
        
        func failed(message: String) {
            
        }
        
        func foundQRCode(code: String) {
            parent.viewModel.code = code
            parent.viewModel.shouldScan = false
            parent.viewModel.state = .showReward
        }
        
        func stopedRunning() {
            
        }
    }
}
