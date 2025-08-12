//
//  RoomCaptureContainerView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import RoomPlan

struct RoomCaptureContainerView: UIViewRepresentable {
    var roomController: RoomCaptureController
    
    func makeUIView(context: Context) -> RoomCaptureView {
        return roomController.captureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {
    }
}
