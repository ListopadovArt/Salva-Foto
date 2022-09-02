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
    
    func performRandomPhotosRequest(with urlString: String, completion: @escaping (Result<[ImageData],NetworkError>) -> Void){
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
                        let image = try decoder.decode([ImageData].self, from: data)
                        completion(.success(image))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
            task.resume()
        }
    }
    
    func performPhotoSearchRequest(with urlString: String, completion: @escaping (Result<SearchImages,NetworkError>) -> Void){
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
                        let image = try decoder.decode(SearchImages.self, from: data)
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
