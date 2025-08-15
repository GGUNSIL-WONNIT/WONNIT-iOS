//
//  ImageUploaderWithMLComponentView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import CoreML

struct ImageUploaderWithMLComponentView: View {
    @Environment(FormStateStore.self) private var store
    
    let config: FormFieldBaseConfig
    let variant: ImageUploaderVariant?
    
    @Binding var images: [UIImage]
    
    @State private var isShowingPicker: Bool = false
    @State private var isShowingCamera: Bool = false
    @State private var draggedImage: UIImage?
    
    @State private var spaceCategoryPrediction: SpaceCategoryClassifierPrediction? = nil
    @State private var detectedSpaceItems: [String] = []
    
    private let spaceCategoryClassifier = SpaceCategoryClassifier.shared
    private let spaceItemDetector = SpaceItemDetector.shared
    
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
//        .onChange(of: spaceCategoryPrediction) {
//            if let prediction = spaceCategoryPrediction?.label, let key = config.spaceCategoryFormComponentKey {
//                store.textValues[key] = prediction.label
//            }
//        }
//        .onChange(of: detectedSpaceItems) { _, new in
//            if let key = config.spaceTagFormComponentKey {
//                let existing = store.tagsValues[key] ?? []
//                let merged = Array(Set(existing + new)).sorted()
//                store.tagsValues[key] = merged
//            }
//        }
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
                                VStack(alignment: .leading, spacing: 6) {
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
                                    }
                                    
                                    if !detectedSpaceItems.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 6) {
                                                ForEach(detectedSpaceItems, id: \.self) { tag in
                                                    Text(tag)
                                                        .font(.system(size: 11, weight: .regular))
                                                        .foregroundStyle(Color.grey900)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(.thinMaterial)
                                                        .clipShape(Capsule())
                                                }
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(10)
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
        VStack(alignment: .leading) {
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
                
                if !detectedSpaceItems.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(detectedSpaceItems, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundStyle(Color.grey900)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.thinMaterial)
                                    .clipShape(Capsule())
                            }
                        }
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
    
    private func detectAndStoreSpaceItemsIntoTags(for images: [UIImage]) {
        Task.detached(priority: .userInitiated) { [spaceItemDetector] in
            let perImage: [[SpaceItem]] = await withTaskGroup(of: [SpaceItem].self) { group in
                for img in images {
                    group.addTask { @Sendable in
                        (try? await spaceItemDetector.topLabels(in: img, minConfidence: 0.40, maxItems: 8)) ?? []
                    }
                }
                var acc: [[SpaceItem]] = []
                for await chunk in group { acc.append(chunk) }
                return acc
            }
            
            let uniqueItems = Array(Set(perImage.flatMap { $0 }))
                .sorted { $0.rawValue < $1.rawValue }
            
            let newDisplayTags = uniqueItems.map { $0.displayLabel }
            
            await MainActor.run {
                self.detectedSpaceItems = newDisplayTags
                
                if let key = config.spaceTagFormComponentKey {
                    let existing = store.tagsValues[key] ?? []
                    let merged = Array(Set(existing + newDisplayTags)).sorted()
                    store.tagsValues[key] = merged
                }
            }
        }
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
                        await MainActor.run {
                            self.spaceCategoryPrediction = preds.first
                            
                            if let prediction = spaceCategoryPrediction?.label, let key = config.spaceCategoryFormComponentKey {
                                store.textValues[key] = prediction.label
                            }
                        }
                    }
                    
                    detectAndStoreSpaceItemsIntoTags(for: [firstImage])
                }

            case .multipleSmall(let limit):
                let availableSlots = limit - self.images.count
                let taken = Array(newImages.prefix(max(0, availableSlots)))
                guard !taken.isEmpty else { break }
                self.images.append(contentsOf: taken)
                detectAndStoreSpaceItemsIntoTags(for: taken)
                
            default:
                return
            }
        }
    }
}

