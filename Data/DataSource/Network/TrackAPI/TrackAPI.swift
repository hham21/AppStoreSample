//
//  TrackAPI.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/04.
//

import Moya

public enum TrackAPI {
    case searchTracks(query: String)
}

extension TrackAPI: TargetType {
    struct Const {
        static let term = "term"
        static let country = "country"
        static let media = "media"
        static let lang = "lang"
        static let limit = "limit"
    }
    
    public var defaultOptions: [String: Any] {
        return [Const.country: "KR",
                Const.media: "software",
                Const.lang: "ko_kr",
                Const.limit: "50"]
    }
    
    public var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
    
    public var path: String {
        switch self {
        case .searchTracks:
            return "/search"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .searchTracks:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .searchTracks:
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchTracks(let query):
            return [Const.term: query,
                    Const.country: "KR",
                    Const.media: "software",
                    Const.lang: "ko_kr",
                    Const.limit: "50"]
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
