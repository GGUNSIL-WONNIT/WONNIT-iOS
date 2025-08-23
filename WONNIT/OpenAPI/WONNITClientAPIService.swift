//
//  WONNITClientAPIService.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import Foundation
import OpenAPIURLSession
import OpenAPIRuntime

public actor WONNITClientAPIService {
    
    static let shared = WONNITClientAPIService()
    
    func client() throws -> Client {
        let serverURL = try Servers.Server1.url()
        
        return Client(
            serverURL: serverURL,
            transport: URLSessionTransport()
        )
    }
}

enum FetchState {
    case loading
    case success(Space)
    case failure
}
