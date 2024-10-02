//
//  File.swift
//  
//
//  Created by 이영호 on 10/2/24.
//

import UIKit
import AVFoundation

enum ReaderStatus { // 바코드를 읽었을때의 상태
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: AnyObject {
    func readerComplete(status: ReaderStatus)
}

class ReaderView: UIView {  // 바코드 스캔 화면

    weak var delegate: ReaderViewDelegate?
    
    var previewLayer: AVCaptureVideoPreviewLayer? // 카메라 미리보기
    var centerGuideLineView: UIView? //
    
    var captureSession: AVCaptureSession?
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        return captureSession.isRunning
    }

    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5, .qr] // 바코드 종류

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetupView()
    }
    
    private func initialSetupView() {
        self.clipsToBounds = true // View가 경계를 넘을시 cut
        self.captureSession = AVCaptureSession()
        
        
        // 장치 설정
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // 장치 설정 중 예기치 못한 이벤트 발생 시 ReaderStatus - fail 호출
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
        
        
        // 원하는 프레임에서만 바코드를 인식할 수 있게 설정
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
        } else {
            self.fail()
            return
        }
        // 카메라 미리보기에 바코드 인식 가이드 라인 지정
        self.setPreviewLayer()
        self.setCenterGuideLineView()
    }
    // 카메라 미리보기
    private func setPreviewLayer() {
        guard let captureSession = self.captureSession else {
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    // 바코드 인식 가이드 라인
    private func setCenterGuideLineView() {
        let centerGuideLineView = UIView()
        centerGuideLineView.translatesAutoresizingMaskIntoConstraints = false
        centerGuideLineView.backgroundColor = UIColor.red
        self.addSubview(centerGuideLineView)
        self.bringSubviewToFront(centerGuideLineView)

        centerGuideLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        centerGuideLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        centerGuideLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        centerGuideLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        self.centerGuideLineView = centerGuideLineView
    }
}
// 바코드 인식 뷰 작동 함수 정의
extension ReaderView {
    func start() { // 캡쳐 시작
        self.captureSession?.startRunning()
    }
    
    func stop(isButtonTap: Bool) { // 캡쳐 중단 또는 바코드 인식 후 자동 중단
        self.captureSession?.stopRunning()
        self.delegate?.readerComplete(status: .stop(isButtonTap))
    }
    
    func fail() { // 바코드 인식 에러
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) { // 바코드 인식 성공
        self.delegate?.readerComplete(status: .success(code))
    }
}

extension ReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stop(isButtonTap: false)
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}
