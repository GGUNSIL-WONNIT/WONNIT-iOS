//
//  KakaoAPI.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/17/25.
//

import Foundation
import Moya

enum KakaoAPI {
    case geocode(query: String)
}

extension KakaoAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
    
    var path: String {
        switch self {
        case .geocode:
            return "/v2/local/search/address.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .geocode(let query):
            let params: [String: Any] = ["query": query]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let restAPIKey = Secrets.kakao
        return ["Authorization": "KakaoAK \(restAPIKey)"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
