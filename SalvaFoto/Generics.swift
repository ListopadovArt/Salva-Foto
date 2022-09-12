//
//  Generics.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 12.09.22.
//

import Foundation

public struct ResponseError: Codable {
    public let error: String
    public let description: String
    
    private enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
}

public struct Link: Codable {
    public let url: URL?
}

public struct Links: Codable {
    public let main: URL
    public let html: URL?
    public let download: URL?
    public let downloadLocation: URL?
    public let photos: URL?
    public let likes: URL?
    public let portfolio: URL?
    public let followers: URL?
    public let following: URL?
    
    private enum CodingKeys: String, CodingKey {
        case main = "self"
        case html
        case download
        case downloadLocation = "download_location"
        case photos
        case likes
        case portfolio
        case followers
        case following
    }
}

public struct Category: Codable {
    public let id: UInt32
    public let title: String
    public let photoCount: UInt32
    public let links: Links?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case photoCount = "photo_count"
        case links
    }
}

public struct StatusCode: Codable {
    public let code: Int
}

