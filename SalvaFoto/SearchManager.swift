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
    
    func performRandomPhotosRequest(with urlString: String, complition: @escaping ([ImageData]) -> Void){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                }
                if let safeData = data {
                    if let image = self.parseJSON(safeData) {
                        complition(image)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [ImageData]? {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedData = try decoder.decode([ImageData].self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    func performSearchRequest(with urlString: String, complition: @escaping ([ImageData]) -> Void){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                }
                if let safeData = data {
                    if let image = self.parseSearchJSON(safeData) {
                        complition(image.results)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseSearchJSON(_ data: Data) -> SearchImages? {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedData = try decoder.decode(SearchImages.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}

