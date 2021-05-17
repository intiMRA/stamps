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
                QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)
                
                VStack {
                    VStack {
                        Text("Keep scanning for QR-codes")
                            .font(.subheadline)
                        Text(self.viewModel.lastQrCode)
                            .bold()
                            .lineLimit(5)
                            .padding()
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                    HStack {
                        Button(action: {
                            self.viewModel.torchIsOn.toggle()
                        }, label: {
                            Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                                .imageScale(.large)
                                .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                                .padding()
                        })
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .onTapGesture(count: 1, perform: {
                    viewModel.lastQrCode = ""
                })
                .padding()
            }
        }
}

struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView()
    }
}
