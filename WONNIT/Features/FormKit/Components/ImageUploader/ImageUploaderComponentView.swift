//
//  ImageUploaderComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import CoreML

struct ImageDropDelegate: DropDelegate {
    let item: UIImage
    @Binding var items: [UIImage]
    @Binding var draggedItem: UIImage?
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = self.draggedItem,
              let fromIndex = items.firstIndex(of: draggedItem),
              let toIndex = items.firstIndex(of: item)
        else {
            return false
        }
        
        withAnimation(.spring()) {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
        
        self.draggedItem = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

struct ImageUploaderComponentView: View {
    let config: FormFieldBaseConfig
    let variant: ImageUploaderVariant?
    
    @Binding var images: [UIImage]
    
    @State private var isShowingPicker: Bool = false
    @State private var isShowingCamera: Bool = false
    @State private var draggedImage: UIImage?
    
    @State private var spaceCategoryPrediction: SpaceCategoryClassifierPrediction? = nil
    
    private let spaceCategoryClassifier = SpaceCategoryClassifier.shared
    
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
            
            switch variant {
            case .singleLarge:
                singleImageUploader
            case .multipleSmall(let limit):
                multipleImageUploader(limit: limit)
            case .none:
                Text("⚠️")
            }
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
    
    private var singleImageUploader: some View {
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
                            .overlay(alignment: .bottomLeading) {
                                if let prediction = spaceCategoryPrediction?.label {
                                    HStack(spacing: 8) {
                                        Text("공간 분류: \(prediction.label)")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(Color.grey900)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(10)
                                }
                    }
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
    
    private func multipleImageUploader(limit: Int) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(images, id: \.self) { image in
                    imageThumbnail(image: image)
                        .onDrag {
                            self.draggedImage = image
                            return NSItemProvider(object: image)
                        }
                        .onDrop(of: [UTType.image],
                                delegate: ImageDropDelegate(item: image, items: $images, draggedItem: $draggedImage))
                }
                
                if images.count < limit {
                    addNewPhotoButton(limit: limit)
                }
            }
            .padding(.top, 7)
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
        
        switch variant {
        case .singleLarge:
            config.selectionLimit = 1
        case .multipleSmall(let limit):
            config.selectionLimit = limit - images.count
        default:
            config.selectionLimit = 0
        }
        return config
    }
    
    private func handleNewImages(_ newImages: [UIImage]) {
        withAnimation(.spring()) {
            switch variant {
            case .singleLarge:
                if let firstImage = newImages.first {
                    self.images = [firstImage]
                    self.spaceCategoryPrediction = nil
                    
                    Task.detached(priority: .userInitiated) { [image = firstImage] in
                        let preds = (try? await spaceCategoryClassifier.classifyTopK(image, k: 1)) ?? []
                        await MainActor.run { self.spaceCategoryPrediction = preds.first }
                    }
                }

            case .multipleSmall(let limit):
                let availableSlots = limit - self.images.count
                self.images.append(contentsOf: newImages.prefix(availableSlots))
            default:
                return
            }
        }
    }
}

