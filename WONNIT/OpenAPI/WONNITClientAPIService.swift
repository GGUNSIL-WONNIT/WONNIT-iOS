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
        
        var cfg = Configuration()
        cfg.dateTranscoder = WONNITDateTranscoder()
        
        return Client(
            serverURL: serverURL,
            configuration: cfg,
            transport: URLSessionTransport()
        )
    }
}

enum FetchState {
    case loading
    case success(Space)
    case failure
}

enum WONNITDateError: Error, LocalizedError {
    case couldNotDecode(String)
    var errorDescription: String? {
        switch self {
        case .couldNotDecode(let s): return "Could not decode date: \(s)"
        }
    }
}

struct WONNITDateTranscoder: DateTranscoder {
    private static let isoStrict: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime] // RFC 3339
        return f
    }()
    
    private static let isoWithFraction: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
    
    private static let noTZ: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()
    
    func decode(_ string: String) throws -> Date {
        if let d = Self.isoStrict.date(from: string) { return d }
        if let d = Self.isoWithFraction.date(from: string) { return d }
        if let d = Self.noTZ.date(from: string) { return d }
        throw WONNITDateError.couldNotDecode(string)
    }
    
    func encode(_ date: Date) -> String {
        return Self.isoStrict.string(from: date)
    }
}
