//
//  PhotoManager.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 3.08.22.
//

import Foundation

class SearchManager {
    
    static let shared = SearchManager()
    
    init() {}
    
    let accessKey = "&client_id=f9U4wUpQbGa7KBTGQp-J8umBGGWBLaTJfiaKcOkBfn0"
    let host = "https://api.unsplash.com/"
    
    func performRandomPhotosRequest(completion: @escaping GenericCompletionManager<[Photo]>){
        let urlString = "\(host)photos/random/?count=30\(accessKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
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
    
    func performPhotoSearchRequest(with word: String, completion: @escaping GenericCompletionManager<Search>){
        let urlString = "\(host)search/photos?per_page=100&query=\(word)\(accessKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(.failure(.serverError))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let image = try decoder.decode(Search.self, from: data)
                        completion(.success(image))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
            task.resume()
        }
    }
}

