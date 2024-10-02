//
//  File.swift
//  
//
//  Created by 이영호 on 10/1/24.
//

import SwiftUI
import AVFoundation

public struct ReaderViewWrapper: UIViewRepresentable {
    @Binding var scannedCode: String?  // 스캔된 코드를 전달하기 위한 바인딩 변수
    
    public func makeUIView(context: Context) -> ReaderView {
        let readerView = ReaderView()
        readerView.delegate = context.coordinator  // Delegate 설정
        return readerView
    }
    
    public func updateUIView(_ uiView: ReaderView, context: Context) {
        // UI 업데이트 로직이 필요한 경우 처리
    }
        
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, ReaderViewDelegate {
        var parent: ReaderViewWrapper
        
        init(_ parent: ReaderViewWrapper) {
            self.parent = parent
        }
        
        // ReaderViewDelegate 메서드
        public func readerComplete(status: ReaderStatus) { // 스캔 인식 유무
            switch status {
            case let .success(code):
                parent.scannedCode = code // 스캔된 코드 전달
            case .fail:
                parent.scannedCode = nil
            case .stop:
                break
            }
        }
    }
}
