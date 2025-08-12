//
//  RoomScannerComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import RoomPlan

private enum ScannerAlert: Identifiable {
    case error(String)
    case replaceExisting
    
    var id: String {
        switch self {
        case .error(let message): return "error-\(message)"
        case .replaceExisting: return "replace"
        }
    }
}

struct RoomScannerComponentView: View {
    let config: FormFieldBaseConfig
    @Binding var roomData: RoomData?
    
    @State private var isShowingScanner = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var activeAlert: ScannerAlert?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                Text(title).body_02(.grey900)
            }
            
            Button {
                handleTap()
            } label: {
                ZStack {
                    if let thumbnail = roomData?.thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipped()
                            .cornerRadius(8)
                    } else {
                        placeholderView
                    }
                }
                .frame(height: 257)
            }
            .alert(item: $activeAlert) { alert in
                switch alert {
                case .error(let message):
                    return Alert(
                        title: Text("사용 불가"),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                case .replaceExisting:
                    return Alert(
                        title: Text("기존 스캔을 덮어쓸까요?"),
                        message: Text("현재 저장된 스캔과 썸네일이 새 스캔으로 교체됩니다."),
                        primaryButton: .destructive(Text("덮어쓰기")) {
                            isShowingScanner = true
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
            .fullScreenCover(isPresented: $isShowingScanner) {
                RoomScannerHostView(roomData: $roomData)
            }
        }
    }
    
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.grey200, lineWidth: 1)
            .frame(height: 257)
            .overlay(
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color.grey300, style: .init(lineWidth: 1, dash: [4]))
                            .frame(width: 95, height: 95)
                        
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.grey300)
                            .frame(width: 36, height: 36)
                    }
                    
                    Text("더욱 정확한 정보 제공을 위해\n공간을 스캔해보세요.")
                        .body_05(.grey700)
                }
            )
    }
    
    private func handleTap() {
        guard RoomCaptureSession.isSupported else {
            activeAlert = .error("해당 기능이 지원되지 않는 기기입니다.")
            return
        }
        if roomData != nil {
            activeAlert = .replaceExisting
        } else {
            isShowingScanner = true
        }
    }
}
