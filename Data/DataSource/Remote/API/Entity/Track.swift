//
//  Track.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/04.
//

import Foundation
import Domain

struct Response: Codable {
    let count: Int
    let results: [TrackDTO]
    
    enum CodingKeys: String, CodingKey {
        case count = "resultCount"
        case results = "results"
    }
}

struct TrackDTO: DBObject {
    let trackId: Int
    let trackName: String
    let sellerName: String
    let artistName: String
    let artworkURL: String?
    let screenshotURLs: [String]
    let rating: Double?
    let ratingCount: Int?
    let contentRating: String
    let releaseNotes: String?
    let languageCodes: [String]
    let version: String?
    let description: String?
    let fileSizeBytes: String?
    let genres: [String]
    let sellerURL: String?
    let releaseDate: Date?
    
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
    
    var id: String {
        return String(trackId)
    }
    
    init(from decoder: Decoder) throws {
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
    
    init(trackId: Int,
         trackName: String,
         sellerName: String,
         artistName: String,
         artWorkURL: String? = nil,
         screenshotURLs: [String] = [],
         rating: Double? = nil,
         ratingCount: Int?,
         contentRating: String,
         releaseNotes: String?,
         languageCodes: [String] = [],
         version: String? = nil,
         description: String? = nil,
         fileSizeBytes: String? = nil,
         genres: [String] = [],
         sellerURL: String? = nil,
         releaseData: Date? = nil)
    {
        self.trackId = trackId
        self.trackName = trackName
        self.sellerName = sellerName
        self.artistName = artistName
        self.artworkURL = artWorkURL
        self.screenshotURLs = screenshotURLs
        self.rating = rating
        self.ratingCount = ratingCount
        self.contentRating = contentRating
        self.releaseNotes = releaseNotes
        self.languageCodes = languageCodes
        self.version = version
        self.description = description
        self.fileSizeBytes = fileSizeBytes
        self.genres = genres
        self.sellerURL = sellerURL
        self.releaseDate = releaseData
    }
}

extension TrackDTO: DomainConvertibleType {
    func asDomain() -> Track {
        return .init(trackId: trackId,
                     trackName: trackName,
                     sellerName: sellerName,
                     artistName: artistName,
                     artWorkURL: artworkURL,
                     screenshotURLs: screenshotURLs,
                     rating: rating,
                     ratingCount: ratingCount,
                     contentRating: contentRating,
                     releaseNotes: releaseNotes,
                     languageCodes: languageCodes,
                     version: version,
                     description: description,
                     fileSizeBytes: fileSizeBytes,
                     genres: genres,
                     sellerURL: sellerURL,
                     releaseData: releaseDate)
    }
}

extension Track: DBObjectConvertableType {
    func asDBObject() -> TrackDTO {
        return .init(trackId: trackId,
                     trackName: trackName,
                     sellerName: sellerName,
                     artistName: artistName,
                     artWorkURL: artworkURL,
                     screenshotURLs: screenshotURLs,
                     rating: rating,
                     ratingCount: ratingCount,
                     contentRating: contentRating,
                     releaseNotes: releaseNotes,
                     languageCodes: languageCodes,
                     version: version,
                     description: description,
                     fileSizeBytes: fileSizeBytes,
                     genres: genres,
                     sellerURL: sellerURL,
                     releaseData: releaseDate)
    }
}




