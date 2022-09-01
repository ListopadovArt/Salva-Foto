//
//  ProfileManager.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.08.22.
//

import Foundation

class ProfileManager {
    
    static let shared = ProfileManager()
    
    init() {}
    
    func fetchProfile(with urlString: String, completion: @escaping (Result<User,NetworkError>) -> Void){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(.failure(.serverError))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let profile = try decoder.decode(User.self, from: data)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
            task.resume()
        }
    }
}
