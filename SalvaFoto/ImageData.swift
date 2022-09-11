//
//  ImageData.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 3.08.22.
//

import Foundation

struct ImageData: Codable {
    let id: String?
    let createdAt, updatedAt, promotedAt: Date?
    let width, height: Int?
    let color: String?
    let blurHash, searchImageDescription: String?
    let altDescription: JSONNull?
    let urls: Urls
    let links: SearchImageLinks
    let categories: [JSONAny]
    let likes: Int?
    var likedByUser: Bool?
    let currentUserCollections: [JSONAny]
    let sponsorship: JSONNull?
    let topicSubmissions: TopicSubmissions
    let user: User?
    let exif: Exif?
    let location: Location?
    let views, downloads: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case searchImageDescription = "description"
        case altDescription = "alt_description"
        case urls, links, categories, likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case sponsorship
        case topicSubmissions = "topic_submissions"
        case user, exif, location, views, downloads
    }
}

// MARK: - Photo

 struct Like: Codable {
    
     let photo: ImageData?
     let user: User?
    
}

// MARK: - PhotoClass
struct PhotoClass: Codable {
    let id: String?
    let width, height: Int?
    let color, blurHash: String?
    let likes: Int?
    let likedByUser: Bool?
    let photoDescription: String?
    let urls: Urls?
    let links: PhotoLinks?

    enum CodingKeys: String, CodingKey {
        case id, width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case photoDescription = "description"
        case urls, links
    }
}

// MARK: - PhotoLinks
struct PhotoLinks: Codable {
    let linksSelf, html, download: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}

// MARK: - SearchImages
struct SearchImages: Codable {
    let total, totalPages: Int?
    let results: [ImageData]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Exif
struct Exif: Codable {
    
}

// MARK: - SearchImageLinks
struct SearchImageLinks: Codable {
    let linksSelf, html, download, downloadLocation: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Location
struct Location: Codable {
    let title, name, city, country: String?
    let position: Position
}

// MARK: - Position
struct Position: Codable {
    let latitude, longitude: Double?
}

// MARK: - TopicSubmissions
struct TopicSubmissions: Codable {
    let experimental, artsCulture, the3DRenders, wallpapers: The3_DRenders?
    let travel: The3_DRenders?
    let nature, streetPhotography: Nature?
    
    enum CodingKeys: String, CodingKey {
        case experimental
        case artsCulture = "arts-culture"
        case the3DRenders = "3d-renders"
        case wallpapers, travel, nature
        case streetPhotography = "street-photography"
    }
}

// MARK: - The3_DRenders
struct The3_DRenders: Codable {
    let status: String
    let approvedOn: Date?
    
    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

// MARK: - Nature
struct Nature: Codable {
    let status: String
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - User
struct User: Codable {
    let id: String?
    let updatedAt: Date
    let username, name, firstName: String?
    let lastName, twitterUsername: String?
    let portfolioURL: String?
    let bio, location: String?
    let links: UserLinks
    let profileImage: ProfileImage
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos: Int?
    let acceptedTos, forHire: Bool?
    let social: Social
    
    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
        case social
    }
}

// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String?
    let portfolio, following, followers: String?
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String?
}

// MARK: - Social
struct Social: Codable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
    let paypalEmail: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
        case paypalEmail = "paypal_email"
    }
}

struct JSONNull: Codable {
    
}

struct JSONAny: Codable {
    
}
