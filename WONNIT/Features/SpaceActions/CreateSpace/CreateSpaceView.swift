//
//  CreateSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25
//

import SwiftUI
import CoreLocation

struct CreateSpaceView: View {
    @Environment(AppSettings.self) private var appSettings
    
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    @State private var formStore = FormStateStore()
    
    var body: some View {
        MultiStepFormView(
            initialStep: CreateSpaceFormStep.addressAndName,
            donePageView: DonePageView(showConfettiOnAppear: false, isLoading: $isSubmitting, errorMessage: $errorMessage),
            store: formStore,
            onSubmit: { store in
                Task {
                    await handleSubmit(formStore: store)
                }
            }
        )
        .overlay {
            if isSubmitting {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView("등록 중...")
                    .tint(.white)
                    .foregroundStyle(.white)
            }
        }
    }
    
    @MainActor
    private func handleSubmit(formStore: FormStateStore) async {
        isSubmitting = true
        errorMessage = nil
        
        do {
            guard let mainImage = (formStore.imageValues["mainImage"] ?? []).first else { throw MappingError.missingRequiredData(field: "대표 사진") }
            guard let kakaoAddress = formStore.addressValues["address1"] as? KakaoAddress else { throw MappingError.missingRequiredData(field: "주소") }
            guard let coordinates = formStore.coordinateValues["address1"] as? CLLocationCoordinate2D else { throw MappingError.missingRequiredData(field: "좌표") }
            guard let timeRange = formStore.timeRangeValues["openTime"] else { throw MappingError.missingRequiredData(field: "운영 시간") }
            guard let operationDays = formStore.daySetValues["openDay"], !operationDays.isEmpty else { throw MappingError.missingRequiredData(field: "운영 요일") }
            guard let name = formStore.textValues["name"], !name.isEmpty else { throw MappingError.missingRequiredData(field: "공간 이름") }
            guard let area = formStore.doubleValues["area"] as? Double else { throw MappingError.missingRequiredData(field: "공간 크기") }
            
            guard let categoryLabel = formStore.textValues["category"], !categoryLabel.isEmpty else {
                throw MappingError.missingRequiredData(field: "카테고리")
            }
            guard let category = SpaceCategory(label: categoryLabel) else {
                throw MappingError.invalidData(field: "카테고리", value: categoryLabel)
            }
            
            guard let pricing = formStore.amountInfoValues["pricing"] else { throw MappingError.missingRequiredData(field: "금액 정보") }
            guard let contact = formStore.textValues["contact"], !contact.isEmpty else { throw MappingError.missingRequiredData(field: "담당자 연락처") }
            
            let subImages = formStore.imageValues["subImages"] ?? []
            let mainImageURL = try await ImageUploaderService.shared.uploadImage(mainImage)
            let subImageURLs = try await ImageUploaderService.shared.uploadImages(subImages)
            
            let detailedAddress = formStore.textValues["address2"]
            let addressInfo = AddressInfo(address1: kakaoAddress.roadAddress, address2: detailedAddress, lat: coordinates.latitude, lon: coordinates.longitude)
            let operationInfo = OperationalInfo(dayOfWeeks: Array(operationDays), startAt: timeRange.startAt, endAt: timeRange.endAt)
            
            let newSpace = Space(
                id: UUID().uuidString,
                name: name,
                address: addressInfo,
                mainImageURL: mainImageURL,
                subImageURLs: subImageURLs,
                category: category,
                spaceTags: formStore.tagsValues["tags"] ?? [],
                size: area,
                operationInfo: operationInfo,
                amountInfo: pricing,
                spaceModelURL: nil,
                modelThumbnailUrl: nil,
                phoneNumber: .init(value: contact),
                precautions: formStore.textValues["cautions"],
                status: .available
            )
            
            try await postNewSpace(space: newSpace)
            
        } catch {
            print("An error occurred during submission: \(error)")
            errorMessage = "오류: \(error.localizedDescription)"
        }
        
        isSubmitting = false
    }
    
    @MainActor
    private func postNewSpace(space: Space) async throws {
        let client = try await WONNITClientAPIService.shared.client()
        let requestBody = try Components.Schemas.SpaceSaveRequest(from: space)
        
        let response = try await client.createSpace(query: .init(userId: appSettings.selectedTestUserID), body: .json(requestBody))
        
        switch response {
        case .badRequest:
            errorMessage = "요청 형식에 문제가 있습니다. 모든 필수 항목을 입력해주세요."
        case .created:
            errorMessage = nil
        default:
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(response)"])
        }
    }
}

#Preview {
    CreateSpaceView()
}
