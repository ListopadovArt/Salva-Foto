//
//  Photo.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 12.09.22.
//

import UIKit

public struct Photo: Codable {
    public let id: String?
    public let createdAt, updatedAt, promotedAt: Date?
    public let width, height: Int?
    public var hexColor: String?
    public let blurHash, searchImageDescription: String?
    public let urls: PhotoURL?
    public let links: Links
    public let categories: [Category]
    public let likes: Int?
    public var likedByUser: Bool?
    public let currentUserCollections: [Collection]
    public let user: User?
    public let exif: Exif?
    public let location: Location?
    public let views, downloads: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case hexColor = "color"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height
        case blurHash = "blur_hash"
        case searchImageDescription = "description"
        case urls, links, categories, likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case user, exif, location, views, downloads
    }
}

public struct PhotoURL: Codable {
    public let raw: URL?
    public let full: URL?
    public let regular: URL?
    public let small: URL?
    public let thumb: URL?
    public let custom: URL?
}

public struct Exif: Codable {
    public var make: String?
    public var model: String?
    public var exposureTime: String?
    public var aperture: String?
    public var focalLength: String?
    public var iso: UInt32?
    
    private enum CodingKeys: String, CodingKey {
        case make
        case model
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
    
    public init(make: String? = nil, model: String? = nil, exposureTime: String? = nil, aperture: String? = nil, focalLength: String? = nil, iso: UInt32? = nil) {
        self.make = make
        self.model = model
        self.exposureTime = exposureTime
        self.aperture = aperture
        self.focalLength = focalLength
        self.iso = iso
    }
}

public struct Location: Codable {
    public var city: String?
    public var country: String?
    public var position: Position?
    public var name: String?
    public var confidential: Bool?
}

public struct Position: Codable {
    public var latitude: Double?
    public var longitude: Double?
}

public struct Like: Codable {
    public let photo: Photo
    public let user: User
}

