//
//  ImageUploaderSimpleComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/14/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ImageUploaderSimpleComponentView: View {
    @Environment(FormStateStore.self) private var store
    
    let config: FormFieldBaseConfig
    
    @Binding var images: [UIImage]
    
    @State private var isShowingPicker: Bool = false
    @State private var isShowingCamera: Bool = false
    @State private var draggedImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = config.title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .body_02(.grey900)
                    
                    if let description = config.description {
                        Text(description)
                            .body_04(.grey500)
                    }
                }
            }
            
            imageUploaderSimple
            
        }
        .sheet(isPresented: $isShowingPicker) {
            let configuration = createPickerConfiguration()
            ImagePicker(configuration: configuration) { selectedImages in
                handleNewImages(selectedImages)
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraPicker { image in
                handleNewImages([image])
            }
        }
    }
    
    private var imageUploaderSimple: some View {
        Menu {
            Button {
                isShowingCamera = true
            } label: {
                Label("카메라로 찍기", systemImage: "camera")
            }
            
            Button {
                isShowingPicker = true
            } label: {
                Label("사진에서 선택하기", systemImage: "photo.on.rectangle")
            }
        } label: {
            ZStack {
                if let image = images.first {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .cornerRadius(8)
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
                                
//                                Text("대표 이미지를 등록하면\nAI가 공간 카테고리를 추천해드려요.")
//                                    .body_05(.grey700)
                            }
                        )
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .cornerRadius(8)
            .clipped()
            .overlay(alignment: .topTrailing) {
                if !images.isEmpty {
                    Button(action: {
                        withAnimation(.spring()) {
                            images.removeAll()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Circle().fill(Color.grey500))
                            .offset(x: 7, y: -4)
                    }
                }
            }
        }
    }
    
    private func imageThumbnail(image: UIImage) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    draggedImage == image ? RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.5)) : nil
                )
            
            Button(action: {
                withAnimation(.spring()) {
                    images.removeAll { $0 == image }
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Circle().fill(Color.grey500))
                    .offset(x: 7, y: -7)
            }
        }
    }
    
    private func addNewPhotoButton(limit: Int) -> some View {
        Menu {
            Button {
                isShowingCamera = true
            } label: {
                Label("카메라로 찍기", systemImage: "camera")
            }
            
            Button {
                isShowingPicker = true
            } label: {
                Label("사진에서 선택하기", systemImage: "photo.on.rectangle")
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.grey200, lineWidth: 1)
                    .frame(width: 84, height: 84)
                VStack(spacing: 4) {
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.grey300)
                        .frame(width: 36, height: 36)
                    Text("\(images.count)/\(limit)")
                        .font(.caption)
                }
                .foregroundColor(Color.grey700)
            }
        }
    }
    
    private func createPickerConfiguration() -> PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        return config
    }
    
    private func handleNewImages(_ newImages: [UIImage]) {
        withAnimation(.spring()) {
            if let firstImage = newImages.first {
                self.images = [firstImage]
            }
        }
    }
}
