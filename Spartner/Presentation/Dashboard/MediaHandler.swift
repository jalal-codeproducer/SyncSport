//
//  FrameHandler.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 15.05.25.
//

import Foundation
import AVFoundation
import CoreImage
import Combine

class MediaHandler: NSObject, ObservableObject {
    let framePublisher = PassthroughSubject<String, Never>()
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    override init() {
        super.init()
        checkCameraPermission()
        sessionQueue.async { [weak self] in
            self?.setupCaptureSession()
            self?.captureSession.startRunning()
        }
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.permissionGranted = granted
            }
        }
    }
    
    func setupCaptureSession() {
        guard permissionGranted else { return }
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .front) else {
            return
        }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput
            .setSampleBufferDelegate(
                self,
                queue: DispatchQueue(label: "sampleBufferQueue")
            )
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
    }
}

extension MediaHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        imageFromSampleBuffer(sampleBuffer: sampleBuffer)
        

    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        
        framePublisher.send(ImageUtilities.cgImageToBase64String(cgImage) ?? "")
        
    }
}
