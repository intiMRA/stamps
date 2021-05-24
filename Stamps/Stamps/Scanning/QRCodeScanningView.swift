//
//  QRCodeScanningView.swift
//  Stamps
//
//  Created by Inti Albuquerque on 18/05/21.
//

import AVFoundation
import UIKit

protocol QRCodeScanningViewDelegate: AnyObject {
    func failed(message: String)
    func foundQRCode(code: String)
    func stopedRunning()
}

class QRCodeScanningView: UIView {
    weak var delegate: QRCodeScanningViewDelegate?
    
    /// capture settion which allows us to start and stop scanning.
    var captureSession: AVCaptureSession?
    
    // Init methods..
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInitialSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitialSetup()
    }
    
    //MARK: overriding the layerClass to return `AVCaptureVideoPreviewLayer`.
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
    
    func setup(delegate: QRCodeScanningViewDelegate) {
        self.delegate = delegate
        self.startScanning()
    }
}

extension QRCodeScanningView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
        captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.stopedRunning()
    }
    
    private func setupSession(videoCaptureDevice: AVCaptureDevice) {
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            scanningDidFail()
            return
        }
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
    }
    /// Does the initial setup for captureSession
    private func doInitialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        if let videoCaptureDevice = AVCaptureDevice.default(for: .video) {
            self.setupSession(videoCaptureDevice: videoCaptureDevice)
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.setupSession(videoCaptureDevice: AVCaptureDevice.default(for: .video)!)
            }
        }
    }
    func scanningDidFail() {
        delegate?.failed(message: "cant scan")
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.foundQRCode(code: code)
    }
    
}

extension QRCodeScanningView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
}
