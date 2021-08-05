//
//  ScanQRCodeViewController.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 05/05/21.
//
// Inpired from here : https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code

import Foundation
import UIKit
import AVFoundation

class ScanQRCodeViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate, Storyboarded {
    
    var viewModel : ScanViewModel!
    
    private var captureSession : AVCaptureSession!
    private var previewLayer : AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var flashLightButton: UIButton!
    
    private var torchIsOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSession()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViews()
    }
    
    private func configureViews(){
        maskView.backgroundColor = .clear
        
        addOverlay()
        addCameraBorder()
    }
    
    @IBAction func torchButtonTapped(_ sender: Any) {
        toggleTorch(on: !torchIsOn)
        torchIsOn = !torchIsOn
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        viewModel.goBack()
    }
    
    
    private func addCameraBorder(){
        
        // Add full border
        let borderLayer = CAShapeLayer.init()
        borderLayer.path = UIBezierPath.init(rect: maskView.bounds).cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2.0
        borderLayer.lineDashPattern = [20, 20]
        borderLayer.strokeColor = UIColor.white.cgColor
        
        // Add Corners
        let path = UIBezierPath.init()
        let segmentLength : CGFloat = 30
        
        path.move(to: CGPoint(x: 0, y: segmentLength))
        path.addLine(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: segmentLength, y: 0))
        path.stroke()

        path.move(to: CGPoint(x: maskView.bounds.maxX, y: segmentLength))
        path.addLine(to: CGPoint(x: maskView.bounds.maxX, y: 0))
        path.addLine(to: CGPoint(x: maskView.bounds.maxX - segmentLength, y: 0))
        path.stroke()

        path.move(to: CGPoint(x: 0, y: maskView.bounds.maxY - segmentLength))
        path.addLine(to: CGPoint(x: 0, y: maskView.bounds.maxY))
        path.addLine(to: CGPoint(x: segmentLength, y: maskView.bounds.maxY))
        path.stroke()

        path.move(to: CGPoint(x: maskView.bounds.maxX - segmentLength, y: maskView.bounds.maxY))
        path.addLine(to: CGPoint(x: maskView.bounds.maxX, y: maskView.bounds.maxY))
        path.addLine(to: CGPoint(x: maskView.bounds.maxX, y: maskView.bounds.maxY - segmentLength))
        path.stroke()
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 8
        
        maskView.layer.addSublayer(borderLayer)
        maskView.layer.addSublayer(shapeLayer)
    }
    
    private func addOverlay(){
        // add overlay
        let maskLayer = CAShapeLayer.init()
        
        let path = UIBezierPath.init(rect: cameraView.frame)
        path.append(UIBezierPath.init(rect: maskView.frame))
        
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.3
        
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // MARK: CODE FOUND
    func found(code: String) {
        viewModel.goToDetail(id: code)
    }
    
    
    // MARK: SESSION CONFIGS
    private func configureSession(){
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

