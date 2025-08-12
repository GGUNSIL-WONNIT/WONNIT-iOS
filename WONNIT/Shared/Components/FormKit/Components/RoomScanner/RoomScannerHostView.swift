//
//  RoomScannerHostView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import RoomPlan

struct RoomScannerHostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var roomController = RoomCaptureController.shared
    @State private var roomScanStorageManager = ScanStorageManager.shared
    
    @Binding var roomData: RoomData?
    
    @State private var isScanning = true
    @State private var isSaving = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            RoomCaptureContainerView()
                .ignoresSafeArea()
                .onAppear(perform: roomController.startSession)
            
            VStack {
                Spacer()
                
                if isScanning {
                    if roomController.isProcessing {
                        progressView(text: "스캔 처리 중...")
                    } else {
                        Button("스캔 끝내기") {
                            roomController.stopSession()
                        }
                        .buttonStyle(ScannerButtonStyle())
                    }
                } else if isSaving {
                    progressView(text: "저장 중...")
                } else {
                    if let errorMessage = errorMessage {
                        errorView(errorMessage)
                    } else if roomController.finalResult != nil {
                        saveButton()
                    } else {
                        errorView("스캔을 완료하지 못했습니다.")
                    }
                }
            }
            .padding(.bottom, 20)
            .onChange(of: roomController.isProcessing) { _, newValue in
                if isScanning && !newValue {
                    isScanning = false
                    if roomController.finalResult == nil {
                        errorMessage = "최종 모델을 가져오지 못했습니다."
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func progressView(text: String) -> some View {
        VStack {
            ProgressView().tint(.white)
            Text(text).foregroundColor(.white).padding(.top, 8)
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 15) {
            Text("오류: \(message)")
                .foregroundColor(.white)
                .padding()
                .background(Color.red.opacity(0.7))
                .cornerRadius(8)
            
            HStack(spacing: 20) {
                Button("다시 스캔하기") {
                    errorMessage = nil
                    isScanning = true
                    roomController.startSession()
                }
                .buttonStyle(ScannerButtonStyle(color: .blue))
                
                Button("취소") {
                    dismiss()
                }
                .buttonStyle(ScannerButtonStyle(color: .gray))
            }
        }
    }
    
    @ViewBuilder
    private func saveButton() -> some View {
        Button {
            isSaving = true
            Task {
                if let result = roomController.finalResult,
                   let data = await roomScanStorageManager.save(capturedRoom: result) {
                    await MainActor.run {
                        self.roomData = data
                        self.isSaving = false
                        self.dismiss()
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "저장에 실패했습니다."
                        self.isSaving = false
                    }
                }
            }
        } label: {
            Text("저장하기")
        }
        .buttonStyle(ScannerButtonStyle(color: .green))
    }
}

private struct ScannerButtonStyle: ButtonStyle {
    var color: Color = .black
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .font(.headline)
            .padding()
            .background(color.opacity(0.8))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
