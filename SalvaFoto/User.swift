//
//  User.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 12.09.22.
//

import Foundation

public struct User: Codable {
    public let id: String?
    public var username: String?
    public let name: String?
    public var firstName: String?
    public var lastName: String?
    public let twitterUsername: String?
    public let downloads: UInt32?
    public let profileImage: ProfilePhotoURL?
    public let links: Links?
    public var portfolioURL: URL?
    public var bio: String?
    public let uploadsRemaining: UInt32?
    public var instagramUsername: String?
    public var location: String?
    public var email: String?
    public let totalLikes: UInt32?
    public let totalPhotos: UInt32?
    public let totalCollections: UInt32?
    public let followersCount: UInt32?
    public let followingCount: UInt32?
    public let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case downloads
        case profileImage = "profile_image"
        case links
        case portfolioURL = "portfolio_url"
        case bio
        case uploadsRemaining = "uploads_remaining"
        case instagramUsername = "instagram_username"
        case location
        case email
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case photos
    }
}

public struct ProfilePhotoURL: Codable {
    public let large: URL?
    public let medium: URL?
    public let small: URL?
    public let custom: URL?
}

