//
//  ImageUploaderComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct ImageUploaderComponentView: View {
    let id: String
    let title: String?
    let variant: ImageUploaderVariant?
    
    @Binding var images: [UIImage]
    @FocusState.Binding var focusedField: String?
    
    @State private var isShowingImagePicker: Bool = false
    @State private var showSourceActionSheet: Bool = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                Text(title)
                    .body_02(.grey900)
            }
            
            switch variant {
            case .singleLarge:
                singleImageUploader
            case .multipleSmall(let limit):
                multipleImageUploader(limit: limit)
            case .none:
                Text("⚠️")
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: pickerSourceType) { image in
                handleNewImage(image)
            }
        }
        .confirmationDialog("이미지를 선택하세요", isPresented: $showSourceActionSheet) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("카메라") {
                    pickerSourceType = .camera
                    isShowingImagePicker = true
                }
            }
            Button("사진 보관함") {
                pickerSourceType = .photoLibrary
                isShowingImagePicker = true
            }
            Button("취소", role: .cancel) {}
        }
    }
    
    private var singleImageUploader: some View {
        Button {
            showSourceActionSheet = true
        } label: {
            ZStack {
                if let image = images.first {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(12)
                } else {
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
                                
                                Text("대표 이미지를 등록하면\nAI가 공간 카테고리를 추천해드려요.")
                                    .body_05(.grey700)
                            }
                        )
                }
            }
        }
    }

    private func multipleImageUploader(limit: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 84, height: 84)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    if images.count < limit {
                        Button {
                            showSourceActionSheet = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.grey200, lineWidth: 1)
                                    .frame(width: 84, height: 84)
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.grey300)
                                    .frame(width: 36, height: 36)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handleNewImage(_ image: UIImage) {
        switch variant {
        case .singleLarge:
            images = [image]
        case .multipleSmall(let limit):
            if images.count < limit {
                images.append(image)
            }
        case .none:
            return
        }
    }
}

#Preview {
    @Previewable @State var images: [UIImage] = []
    @FocusState var focusedField: String?
    
    VStack(spacing: 32) {
        ImageUploaderComponentView(id: "Image1", title: "대표사진 등록", variant: .singleLarge, images: $images, focusedField: $focusedField)
        
        ImageUploaderComponentView(id: "Image2", title: "추가사진 등록", variant: .multipleSmall(limit: 5), images: $images, focusedField: $focusedField)
    }
    .padding()
}
