//
//  Authenticator.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 1.09.22.
//

import Foundation
import AuthenticationServices

private struct OAuthParameters {
    public var authorizeUrl: String
    public var tokenUrl: String
    public var clientId: String
    public var clientSecret: String
    public var redirectUri: String
    public var callbackURLScheme: String
}

public struct AccessTokenResponse: Codable {
    public var accessToken, tokenType, scope: String
    public var createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

public class Authenticator: NSObject {
    
    public func authenticate(completion: @escaping GenericCompletionAuthenticator<AccessTokenResponse>){
        
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let host = "https://unsplash.com"
        let authorizeURL = "\(host)/oauth/authorize"
        let tokenURL = "\(host)/oauth/token"
        let clientId = "f9U4wUpQbGa7KBTGQp-J8umBGGWBLaTJfiaKcOkBfn0"
        let clientSecret = "7FHZh8Q_0E0B19tj8X6ywRYRzQFEdOFtC4sDgzmBook"
        let redirectUri = "\(bundleIdentifier)://localhost/redirect"
        
        let parameters = OAuthParameters(authorizeUrl: authorizeURL,
                                         tokenUrl:tokenURL,
                                         clientId: clientId,
                                         clientSecret: clientSecret,
                                         redirectUri: redirectUri,
                                         callbackURLScheme: bundleIdentifier)
        
        let authenticationSession = ASWebAuthenticationSession(
            url: URL(string: "\(parameters.authorizeUrl)?response_type=code&client_id=\(parameters.clientId)&redirect_uri=\(parameters.redirectUri)&scope=public+read_user+write_user+read_photos+write_photos+write_likes+read_collections+write_collections")!,
            callbackURLScheme: parameters.callbackURLScheme) { optionalUrl, optionalError in
                
                guard optionalError == nil else { completion(.failure(.authRequestFailed(optionalError!)))
                    return
                }
                guard let url = optionalUrl else { completion(.failure(.authorizeResponseNoUrl))
                    return
                }
                guard let code = url.getQueryStringParameter("code") else { completion(.failure(.authorizeResponseNoCode))
                    return
                }
                
                self.getAccessToken(authCode: code, parameters: parameters, completion: completion)
            }
        authenticationSession.presentationContextProvider = self
        authenticationSession.start()
    }
    
    private func getAccessToken(authCode: String, parameters: OAuthParameters, completion: @escaping GenericCompletionAuthenticator<AccessTokenResponse>){
        
        let url = URL(string: "\(parameters.tokenUrl)?client_id=\(parameters.clientId)&client_secret=\(parameters.clientSecret)&redirect_uri=\(parameters.redirectUri)&code=\(authCode)&grant_type=authorization_code")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.tokenRequestFailed(error)))
                }
            }
            
            guard let data = data else { return }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.tokenResponseNoData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let result = try decoder.decode(AccessTokenResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.tokenResponseInvalidData(authCode)))
                }
            }
        }
        task.resume()
    }
}


//MARK: - Extensions
extension Authenticator: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession)
    -> ASPresentationAnchor {
        let window = UIApplication.shared.keyWindow
        return window ?? ASPresentationAnchor()
    }
}

private extension URL {
    func getQueryStringParameter(_ parameter: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == parameter })?.value
    }
}

private extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

