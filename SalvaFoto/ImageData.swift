//
//  ImageData.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 3.08.22.
//

import Foundation

struct ImageData: Codable {
    let id: String?
    let created_at, updated_at: String?
    let promoted_at: String?
    let width, height: Int?
    let color, blur_hash: String?
    let description, alt_description: String?
    let urls: Urls
    let links: WelcomeLinks
    let categories: [JSONAny]
    let likes: Int?
    let liked_by_user: Bool?
    let current_user_collections: [JSONAny]
    let sponsorship: Sponsorship?
    let topic_submissions: TopicSubmissions
    let user: User?
}

struct Urls: Codable {
    let raw, full, regular, small: String?
        let thumb, small_s3: String?
}

struct WelcomeLinks: Codable {
    
}

struct JSONAny: Codable {
    
}

struct Sponsorship: Codable {
   
}

struct TopicSubmissions: Codable {
    
}

struct User: Codable {
    let id: String
        let updated_at: String?
        let username, name, first_name: String?
        let last_name, twitter_username: String?
        let portfolio_url: String?
        let bio, location: String?
        let links: UserLinks
        let profile_image: ProfileImage
        let instagram_username: String?
        let total_collections, total_likes, total_photos: Int?
        let accepted_tos, for_hire: Bool?
        let social: Social
}

struct Social: Codable {
    
}

struct ProfileImage: Codable {
    let small, medium, large: String?
}

struct UserLinks: Codable {
   
}

struct JSONNull: Codable {
   
}
