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
final class RoomCaptureController: NSObject, RoomCaptureViewDelegate, NSCoding {
    static let shared = RoomCaptureController()
    
    var finalResult: CapturedRoom?
    var isProcessing = false
    
    private(set) var captureView: RoomCaptureView
    private var sessionConfig = RoomCaptureSession.Configuration()
    
    private override init() {
        captureView = RoomCaptureView(frame: .zero)
        super.init()
        captureView.delegate = self
    }
    
    required init?(coder: NSCoder) { // NSCoding
        fatalError("not implemented")
    }
    
    func encode(with coder: NSCoder) { // NSCoding
        fatalError("not implemented")
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
            print("\(#fileID) \(#line)-line, \(#function)")
            self.finalResult = nil
        } else {
            self.finalResult = processedResult
        }
        self.isProcessing = false
    }
}
