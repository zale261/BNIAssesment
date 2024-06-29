//
//  ScanQRViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class ScanQRViewController: UIViewController, ScanQRView {
    var presenter: ScanQRPresenter!
    
    private let didScanQRRelay = PublishRelay<String>()
    private let popUpModuleRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private var captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
    }
    
    private func setupUI() {
        title = "Scan QR"
        initQRScanner()
    }
    
    private func initQRScanner() {
        let discoverySession = AVCaptureDevice.default(for: .video)
        
        guard let captureDevice = discoverySession else {
            let alert = UIAlertController(
                title: "Error", message: "Tidak memiliki akses ke kamera",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {[weak self] _ in
                self?.popUpModuleRelay.accept(())
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            let videoMetaDataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(videoMetaDataOutput) {
                captureSession.addOutput(videoMetaDataOutput)
                
                videoMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                videoMetaDataOutput.metadataObjectTypes = [.qr]
                
                let scanRect = CGRect(x: 0,
                                      y: 0,
                                      width: view.frame.height,
                                      height: view.frame.width)
                videoMetaDataOutput.rectOfInterest = scanRect
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = self.view.layer.bounds
            self.view.layer.addSublayer(previewLayer!)
            
            self.cameraStartRunning()
        } catch {
            return
        }
    }
    
    private func cameraStartRunning() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    private func bindPresenter() {
        let input = ScanQRPresenter.Input(
            didScanQR: self.didScanQRRelay.asObservable(),
            popUpModule: popUpModuleRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displayError.drive(onNext: {[weak self] message in
            let alert = UIAlertController(
                title: "Error", message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {[weak self] _ in
                self?.cameraStartRunning()
            }))
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
}

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if let value = metadataObject.stringValue {
                self.didScanQRRelay.accept(value)
                self.captureSession.stopRunning()
            }
        }
    }
    
}
