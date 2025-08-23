import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct Space: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String?
    let address: AddressInfo?
    let mainImageURL: String?
    let subImageURLs: [String]?
    let category: SpaceCategory?
    let spaceTags: [String]?
    let size: Double?
    let operationInfo: OperationalInfo?
    let amountInfo: AmountInfo?
    let spaceModelURL: String?
    let modelThumbnailUrl: String?
    let phoneNumber: PhoneNumber?
    let precautions: String?
    let status: SpaceStatus?
    let beforeImgUrl: String?
    let afterImgUrl: String?
    let resultImgUrl: String?
    let similarity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, spaceId
        case name, address, category, size, operationInfo, amountInfo, phoneNumber, precautions, status, beforeImgUrl, afterImgUrl, resultImgUrl, similarity
        case mainImageURL = "mainImgUrl"
        case subImageURLs = "subImgUrls"
        case spaceTags = "tags"
        case spaceModelURL = "spaceModelUrl"
        case modelThumbnailUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let spaceId = try container.decodeIfPresent(String.self, forKey: .spaceId) {
            self.id = spaceId
        } else {
            self.id = try container.decode(String.self, forKey: .id)
        }
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.address = try container.decodeIfPresent(AddressInfo.self, forKey: .address)
        self.mainImageURL = try container.decodeIfPresent(String.self, forKey: .mainImageURL)
        self.subImageURLs = try container.decodeIfPresent([String].self, forKey: .subImageURLs)
        self.category = try container.decodeIfPresent(SpaceCategory.self, forKey: .category)
        self.spaceTags = try container.decodeIfPresent([String].self, forKey: .spaceTags)
        self.size = try container.decodeIfPresent(Double.self, forKey: .size)
        self.operationInfo = try container.decodeIfPresent(OperationalInfo.self, forKey: .operationInfo)
        self.amountInfo = try container.decodeIfPresent(AmountInfo.self, forKey: .amountInfo)
        self.spaceModelURL = try container.decodeIfPresent(String.self, forKey: .spaceModelURL)
        self.modelThumbnailUrl = try container.decodeIfPresent(String.self, forKey: .modelThumbnailUrl)
        self.phoneNumber = try container.decodeIfPresent(PhoneNumber.self, forKey: .phoneNumber)
        self.precautions = try container.decodeIfPresent(String.self, forKey: .precautions)
        self.status = try container.decodeIfPresent(SpaceStatus.self, forKey: .status)
        self.beforeImgUrl = try container.decodeIfPresent(String.self, forKey: .beforeImgUrl)
        self.afterImgUrl = try container.decodeIfPresent(String.self, forKey: .afterImgUrl)
        self.resultImgUrl = try container.decodeIfPresent(String.self, forKey: .resultImgUrl)
        self.similarity = try container.decodeIfPresent(Double.self, forKey: .similarity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(mainImageURL, forKey: .mainImageURL)
        try container.encodeIfPresent(subImageURLs, forKey: .subImageURLs)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(spaceTags, forKey: .spaceTags)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(operationInfo, forKey: .operationInfo)
        try container.encodeIfPresent(amountInfo, forKey: .amountInfo)
        try container.encodeIfPresent(spaceModelURL, forKey: .spaceModelURL)
        try container.encodeIfPresent(modelThumbnailUrl, forKey: .modelThumbnailUrl)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(precautions, forKey: .precautions)
        try container.encodeIfPresent(status, forKey: .status)
    }
    
    init(id: String, name: String?, address: AddressInfo?, mainImageURL: String?, subImageURLs: [String]?, category: SpaceCategory?, spaceTags: [String]?, size: Double?, operationInfo: OperationalInfo?, amountInfo: AmountInfo?, spaceModelURL: String?, modelThumbnailUrl: String?, phoneNumber: PhoneNumber?, precautions: String?, status: SpaceStatus?, beforeImgUrl: String? = nil, afterImgUrl: String? = nil, resultImgUrl: String? = nil, similarity: Double? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.mainImageURL = mainImageURL
        self.subImageURLs = subImageURLs
        self.category = category
        self.spaceTags = spaceTags
        self.size = size
        self.operationInfo = operationInfo
        self.amountInfo = amountInfo
        self.spaceModelURL = spaceModelURL
        self.modelThumbnailUrl = modelThumbnailUrl
        self.phoneNumber = phoneNumber
        self.precautions = precautions
        self.status = status
        self.beforeImgUrl = beforeImgUrl
        self.afterImgUrl = afterImgUrl
        self.resultImgUrl = resultImgUrl
        self.similarity = similarity
    }
    
    var coordinate: CLLocationCoordinate2D? {
        address?.coordinate
    }
}
