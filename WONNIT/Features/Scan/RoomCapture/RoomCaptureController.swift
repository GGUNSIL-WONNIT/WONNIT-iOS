//
//  RoomCaptureController.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import Foundation
import UIKit
import RoomPlan

@Observable
final class RoomCaptureController: RoomCaptureViewDelegate {
    static let shared = RoomCaptureController()
    
    func encode(with coder: NSCoder) {}
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }

    var finalResult: CapturedRoom?
    var isProcessing = false
    
    var captureView: RoomCaptureView
    private var sessionConfig: RoomCaptureSession.Configuration
    
    init() {
        captureView = RoomCaptureView(frame: .zero)
        sessionConfig = .init()
        captureView.delegate = self
    }
    
    func startSession() {
        finalResult = nil
        isProcessing = false
        captureView.captureSession.run(configuration: sessionConfig)
    }
    
    func stopSession() {
        guard !isProcessing else { return }
        isProcessing = true
        captureView.captureSession.stop()
    }
    
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        if let error = error {
            print("RoomCapture Error: \(error.localizedDescription)")
            finalResult = nil
        } else {
            finalResult = processedResult
        }
        isProcessing = false
    }
}
