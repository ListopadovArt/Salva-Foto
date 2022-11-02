//
//  FavoriteManager.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.08.22.
//

import Foundation

class FavoriteManager {
    
    static let shared = FavoriteManager()
    
    init() {}
    
    func fetchFavoritePhotos(username: String, token: String, completion: @escaping (Result<[Photo],NetworkError>) -> Void){
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/users/\(username)/likes")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let image = try decoder.decode([Photo].self, from: data)
                    completion(.success(image))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
}
