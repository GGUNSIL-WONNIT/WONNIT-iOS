//
//  RoomCaptureContainerView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import RoomPlan

struct RoomCaptureContainerView: UIViewRepresentable {
    func makeUIView(context: Context) -> RoomCaptureView {
        return RoomCaptureController.shared.captureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {
    }
}
