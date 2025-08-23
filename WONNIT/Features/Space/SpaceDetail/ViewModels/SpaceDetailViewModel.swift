//
//  SpaceDetailViewModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import Foundation

@Observable
final class SpaceDetailViewModel {
    var space: Space?
    var errorMessage: String?
    
    var isEditable: Bool = false
    var showEditSpaceForm: Bool = false
    var showUSDZPreview: Bool = false
    
    private let spaceId: String?
    
    init(spaceId: String?) {
        self.spaceId = spaceId
    }
    
    @MainActor
    func fetchIfNeeded() async {
        guard let id = spaceId, space == nil else { return }
        await fetchSpaceDetails(spaceId: id)
    }
    
    @MainActor
    func forceRevalidate() async {
        if let id = spaceId {
            await fetchSpaceDetails(spaceId: id)
        }
    }
    
    @MainActor
    func fetchSpaceDetails(spaceId: String) async {
        do {
            let client = try await WONNITClientAPIService.shared.client()
            let response = try await client.getSpaceDetail(path: .init(spaceId: spaceId))
            let spaceDetail = try response.ok.body.json
            self.space = Space(from: spaceDetail)
            // self.isEditable = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
