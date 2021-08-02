//
//  Track.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation

public struct Track: Codable {
    public let trackId: Int
    public let trackName: String
    public let sellerName: String
    public let artistName: String
    public let artworkURL: String?
    public let screenshotURLs: [String]
    public let rating: Double?
    public let ratingCount: Int?
    public let contentRating: String
    public let releaseNotes: String?
    public let languageCodes: [String]
    public let version: String?
    public let description: String?
    public let fileSizeBytes: String?
    public let genres: [String]
    public let sellerURL: String?
    public let releaseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case trackName = "trackName"
        case sellerName = "sellerName"
        case artistName = "artistName"
        case artworkURL = "artworkUrl100"
        case screenshotURLs = "screenshotUrls"
        case rating = "averageUserRatingForCurrentVersion"
        case ratingCount = "userRatingCountForCurrentVersion"
        case contentRating = "trackContentRating"
        case releaseNotes = "releaseNotes"
        case languageCodes = "languageCodesISO2A"
        case version = "version"
        case description = "description"
        case fileSizeBytes = "fileSizeBytes"
        case genres = "genres"
        case sellerURL = "sellerUrl"
        case releaseDate = "releaseDate"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let date = try values.decode(String.self, forKey: .releaseDate)
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        self.trackId = try values.decode(Int.self, forKey: .trackId)
        self.trackName = try values.decode(String.self, forKey: .trackName)
        self.artistName = try values.decode(String.self, forKey: .artistName)
        self.sellerName = try values.decode(String.self, forKey: .sellerName)
        self.artworkURL = try? values.decode(String.self, forKey: .artworkURL)
        self.screenshotURLs = try values.decode([String].self, forKey: .screenshotURLs)
        self.rating = try? values.decode(Double.self, forKey: .rating)
        self.ratingCount = try? values.decode(Int.self, forKey: .ratingCount)
        self.contentRating = try values.decode(String.self, forKey: .contentRating)
        self.releaseNotes = try? values.decode(String.self, forKey: .releaseNotes)
        self.languageCodes = try values.decode([String].self, forKey: .languageCodes)
        self.version = try? values.decode(String.self, forKey: .version)
        self.description = try? values.decode(String.self, forKey: .description)
        self.fileSizeBytes = try? values.decode(String.self, forKey: .fileSizeBytes)
        self.genres = try values.decode([String].self, forKey: .genres)
        self.sellerURL = try? values.decode(String.self, forKey: .sellerURL)
        self.releaseDate = dateFormatter.date(from: date)
    }
}
