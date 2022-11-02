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
    public let links: Links?
    public let categories: [Category]?
    public let likes: Int?
    public var likedByUser: Bool?
    public let currentUserCollections: [Collection]?
    public let sponsorship: String?
    public let topicSubmissions: TopicSubmissions?
    public let user: User?
    public let exif: Exif?
    public let location: Location?
    public let views, downloads: Int?
    public let tags: [Tag]?
    
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
        case sponsorship, topicSubmissions, user, exif, location, views, downloads, tags
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
    public let photo: Photo?
    public let user: User?
}

// MARK: - TopicSubmissions
public struct TopicSubmissions: Codable {
    let wallpapers: The3_DRenders?
    let architecture: Architecture?
    let the3DRenders, people, spirituality, experimental: The3_DRenders?
    let texturesPatterns, nature, streetPhotography, fashion: The3_DRenders?
    let travel, foodDrink, film: The3_DRenders?

    enum CodingKeys: String, CodingKey {
        case wallpapers, architecture
        case the3DRenders = "3d-renders"
        case people, spirituality, experimental
        case texturesPatterns = "textures-patterns"
        case nature
        case streetPhotography = "street-photography"
        case fashion, travel
        case foodDrink = "food-drink"
        case film
    }
}

// MARK: - Architecture
public struct Architecture: Codable {
    let status: Status?
}

enum Status: String, Codable {
    case approved = "approved"
    case rejected = "rejected"
    case unevaluated = "unevaluated"
}

// MARK: - The3_DRenders
public struct The3_DRenders: Codable {
    let status: Status?
    let approvedOn: Date?

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

// MARK: - Tag
public struct Tag: Codable {
    let title: String
}

// MARK: - Download
struct Download: Codable {
    let url: String
}

