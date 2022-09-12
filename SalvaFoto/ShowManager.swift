//
//  ShowManager.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 6.09.22.
//

import Foundation

class ShowManager {
    
    static let shared = ShowManager()
    
    init() {}
    
    func getPhoto(id: String, token: String, completion: @escaping (Result<Photo,NetworkError>) -> Void){
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/\(id)")!,timeoutInterval: Double.infinity)
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
                    let image = try decoder.decode(Photo.self, from: data)
                    completion(.success(image))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    func setLikeToPhoto(id: String, token: String, user: User, photo: Photo, completion: @escaping (Result<Like,NetworkError>) -> Void) {
        var photo = photo
        photo.likedByUser = true
        let uploadDataModel = Like(photo: photo, user: user)
        
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/\(id)/like")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        request.httpBody = try! JSONEncoder().encode(uploadDataModel)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let image = try decoder.decode(Like.self, from: data)
                    completion(.success(image))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    func removeLikeFromPhoto(id: String, token: String){
        
    }
}

