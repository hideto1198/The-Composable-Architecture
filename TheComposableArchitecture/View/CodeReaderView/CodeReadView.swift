//
//  CodeReadView.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/22.
//

import Foundation
import AVFoundation
import Vision
import UIKit
import SwiftUI

struct CodeReadView: UIViewControllerRepresentable {
    var completion: (Result<String, Error>) -> Void
    
    init(completion: @escaping (Result<String, Error>) -> Void) {
        self.completion = completion
    }
    
    func makeUIViewController(context: Context) -> CodeReaderController {
        let viewController = CodeReaderController(completion: completion)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CodeReaderController, context: Context) {
        
    }
}

class CodeReaderController: UIViewController {
    private let avCaptureSession: AVCaptureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private var lockOnLayer = CALayer()
    private var currentTarget: VNDetectedObjectObservation?
    var completion: (Result<String, Error>) -> Void
    
    init(completion: @escaping (Result<String, Error>) -> Void) {
         self.completion = completion
         super.init(nibName: nil, bundle: nil)
    }
      
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
        setUpLockOnLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sessionQueue = DispatchQueue(label: "session queue")
        sessionQueue.async {
            self.avCaptureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.avCaptureSession.stopRunning()
    }
    
    private func setUpCamera() {
        self.avCaptureSession.sessionPreset = .photo
        
        let device = AVCaptureDevice.default(for: .video)
        let input = try! AVCaptureDeviceInput(device: device!)
        self.avCaptureSession.addInput(input)
        
        let videoDataOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: .global())
        
        self.avCaptureSession.addOutput(videoDataOutput)
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
        let rootLayer = self.view.layer
        self.previewLayer.frame.size = CGSize(width: bounds.width, height: bounds.height)
        self.previewLayer.videoGravity = .resizeAspectFill
        rootLayer.addSublayer(self.previewLayer)
    }
    
    private func setUpLockOnLayer() {
        self.lockOnLayer.borderWidth = 4.0
        self.lockOnLayer.borderColor = UIColor.red.cgColor
        self.lockOnLayer.borderColor = UIColor(red: 0.780, green: 0.898, blue: 0.922, alpha: 1).cgColor
        self.lockOnLayer.cornerRadius = 10.0
        self.lockOnLayer.frame = CGRect(x: (bounds.width / 2) - (bounds.width * 0.25), y: (bounds.height / 2 - (bounds.width * 0.5)), width: bounds.width * 0.5, height: bounds.width * 0.5)
        self.previewLayer.addSublayer(self.lockOnLayer)
    }
    
    private func getQRObservations(pixelBuffer: CVPixelBuffer, completion: @escaping (([VNBarcodeObservation]) -> ())) {
        let request = VNDetectBarcodesRequest { (request, error) in
            guard let results = request.results as? [VNBarcodeObservation] else {
                completion([])
                return
            }
            completion(results)
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
    
}

extension CodeReaderController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let handler = VNSequenceRequestHandler()
        let barcodesDetectionRequest = VNDetectBarcodesRequest(completionHandler: self.handleBarcodes)
        
        try? handler.perform([barcodesDetectionRequest], on: pixelBuffer)
    }
    
    private func handleBarcodes(request: VNRequest, error: Error?) {
        guard let barcode = request.results?.first as? VNBarcodeObservation else {
            return
        }
        let x: CGFloat = barcode.boundingBox.origin.y * bounds.width
        let y: CGFloat = barcode.boundingBox.origin.x * bounds.height
        
        if let value = barcode.payloadStringValue {
            DispatchQueue.main.async {
                if x >= self.lockOnLayer.frame.minX && x <= self.lockOnLayer.frame.maxX && y >= self.lockOnLayer.frame.minY && y <= self.lockOnLayer.frame.maxY {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.avCaptureSession.stopRunning()
                    self.completion(.success(value))
                }
            }
        }
    }
}
