//
//  Track.swift
//  Domain
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import Foundation

public class Track {
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
    
    public init(trackId: Int,
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
