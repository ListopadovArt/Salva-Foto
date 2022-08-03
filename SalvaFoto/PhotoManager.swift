//
//  PhotoManager.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 3.08.22.
//

import Foundation

class PhotoManager {
    
    static let shared = PhotoManager()
    
    init() {}
    
    func performRequest(with urlString: String, complition: @escaping ([ImageData]) -> Void){
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
        do {
            let decodedData = try decoder.decode([ImageData].self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
        
        
    }
    
}

