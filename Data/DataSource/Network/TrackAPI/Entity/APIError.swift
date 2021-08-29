//
//  APIError.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/29.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case invalidResponseCode(Int)
    case invalidJSON
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Server Response"
        case .invalidResponseCode(let code):
            return "Invalid Server Response Code: \(code)"
        case .invalidJSON:
            return "Invalid JSON"
        }
    }
}
