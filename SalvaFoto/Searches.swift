//
//  Searches.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 12.09.22.
//

import Foundation

public struct Search: Codable {
    
    public let total: UInt32?
    public let totalPages: UInt32?
    public let photos: [Photo]?
    public let collections: [Collection]?
    public let users: [User]?
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(UInt32.self, forKey: .total)
        totalPages = try container.decode(UInt32.self, forKey: .totalPages)
        
        do {
            photos = try container.decode([Photo].self, forKey: .results)
            collections = nil
            users = nil
        } catch {
            do {
                collections = try container.decode([Collection].self, forKey: .results)
                photos = nil
                users = nil
            } catch {
                users = try container.decode([User].self, forKey: .results)
                photos = nil
                collections = nil
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(totalPages, forKey: .totalPages)
        do {
            try container.encode(photos, forKey: .results)
        } catch {
            do {
                try container.encode(collections, forKey: .results)
            } catch {
                try container.encode(users, forKey: .results)
            }
        }
    }
}

