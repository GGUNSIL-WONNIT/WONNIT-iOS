//
//  ImageComparisonComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/20/25.
//

import SwiftUI

struct ImageComparisonComponentView: View {
//    @Environment(FormStateStore.self) private var store
    
    let config: FormFieldBaseConfig
    
    @Binding var beforeImage: [UIImage]
    @Binding var afterImage: [UIImage]
    
    @State private var matchPct: Double? = nil
    @State private var maskedImage: UIImage? = nil
    @State private var running = true
    @State private var errorText: String?
    
    private let detector = SpaceChangesMaskPredictor.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleSection
            
            resultsSection
            
            if let e = errorText {
                Text(e)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                run()
            }
        }
    }
    
    @ViewBuilder
    private var titleSection: some View {
        if running {
            HStack {
                Text("이미지 분석 중이에요")
                    .title_01(.grey900)
                ProgressView()
            }
        } else {
            if let matchPct {
                Text("AI 이미지 분석 결과\n대여 이전 상태와 \(String(format: "%.0f",matchPct))% 일치해요")
                    .title_01(.grey900)
            } else {
                Text("AI 이미지 분석에 실패했어요.")
                    .title_01(.grey900)
            }
        }
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        if let maskedImage = maskedImage, let matchPct = matchPct, let after = afterImage.first {
            VStack(spacing: 8) {
                ZStack {
                    Image(uiImage: after)
                        .resizable()
                        .scaledToFit()
                    
                    Image(uiImage: maskedImage)
                        .resizable()
                        .scaledToFit()
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if matchPct < 70 {
                    TooltipView(pointerPlacement: .top, backgroundColor: .grey100) {
                        HStack(spacing: 0) {
                            Text("전후 일치도가")
                                .body_05(.primaryPurple)
                            Text(" 70%보다 낮아요")
                                .body_05(.grey900)
                        }
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                    }
                }
            }
        }
    }
    
    private func run() {
        guard let b = beforeImage.first, let a = afterImage.first else { return }
        
        running = true
        errorText = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            detector.detectChanges(beforeImage: b, afterImage: a) { pct, mask in
                DispatchQueue.main.async {
                    self.maskedImage = mask
                    self.matchPct = pct
                    self.running = false
                }
            }
        }
    }
}

#Preview {
//    @Previewable @State var store = FormStateStore()
    
    @Previewable @State var beforeImage: [UIImage] = [
        UIImage(named: "testing/before") ?? UIImage()
    ]
    
    @Previewable @State var afterImage: [UIImage] = [
        UIImage(named: "testing/after") ?? UIImage()
    ]
    
    ImageComparisonComponentView(config: .init(id: "imageComparison"), beforeImage: $beforeImage, afterImage: $afterImage)
//        .environment(store)
}
