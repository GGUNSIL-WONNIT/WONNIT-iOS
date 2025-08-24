//
//  FormStateStore+Inject.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import Foundation
import CoreLocation
import Kingfisher

extension FormStateStore {
    func inject(from space: Space) async {
        imageValues["mainImage"] = []
        imageValues["subImages"] = []

        async let main: UIImage? = loadMainImage(from: space.mainImageURL)
        async let subs: [UIImage] = loadSubImages(from: space.subImageURLs)
        
        if let address = space.address {
            addressValues["address1"] = KakaoAddress(roadAddress: address.address1, jibunAddress: "", zonecode: "")
            if let coordinate = space.coordinate {
                coordinateValues["address1"] = CLLocationCoordinate2D(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            }
            textValues["address2"] = address.address2
        }
        
        textValues["name"] = space.name
        selectValues["category"] = space.category?.label
        doubleValues["area"] = space.size
        
        if let tags = space.spaceTags {
            tagsValues["spaceTags"] = tags
        }
        
        if let operationalInfo = space.operationInfo {
            daySetValues["openDay"] = Set(operationalInfo.dayOfWeeks)
            timeRangeValues["openTime"] = .init(startAt: operationalInfo.startAt, endAt: operationalInfo.endAt)
        }
        
        if let amountInfo = space.amountInfo {
            amountInfoValues["pricing"] = amountInfo
        }
        
        textValues["contact"] = space.phoneNumber?.value ?? ""
        textValues["cautions"] = space.precautions
        
        if let m = await main {
            imageValues["mainImage"] = [m]
        }
        imageValues["subImages"] = await subs
    }
    
    private func loadMainImage(from urlString: String?) async -> UIImage? {
        guard
            let s = urlString,
            let url = URL(string: s)
        else { return nil }
        
        do {
            let result = try await KingfisherManager.shared.retrieveImage(with: url)
            return result.image
        } catch {
            return nil
        }
    }
    
    private func loadSubImages(from urlStrings: [String?]?) async -> [UIImage] {
        let urls: [URL] = (urlStrings ?? [])
            .compactMap { $0 }
            .compactMap(URL.init(string:))
        
        if urls.isEmpty { return [] }
        
        return await withTaskGroup(of: (Int, UIImage?).self, returning: [UIImage].self) { group in
            for (idx, url) in urls.enumerated() {
                group.addTask {
                    do {
                        let result = try await KingfisherManager.shared.retrieveImage(with: url)
                        return (idx, result.image)
                    } catch {
                        return (idx, nil)
                    }
                }
            }
            var ordered: [UIImage?] = Array(repeating: nil, count: urls.count)
            for await (idx, image) in group {
                ordered[idx] = image
            }
            return ordered.compactMap { $0 }
        }
    }

}
