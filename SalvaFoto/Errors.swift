//
//  Errors.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.08.22.
//

import Foundation

public enum NetworkError: Error {
    case serverError
    case decodingError
}

public enum AuthenticatorError: LocalizedError {
    case authRequestFailed(Error)
    case authorizeResponseNoUrl
    case authorizeResponseNoCode
    case tokenRequestFailed(Error)
    case tokenResponseNoData
    case tokenResponseInvalidData(String)
    
    var localizedDescription: String {
        switch self {
        case .authRequestFailed(let error):
            return "authorization request failed: \(error.localizedDescription)"
        case .authorizeResponseNoUrl:
            return "authorization response does not include a url"
        case .authorizeResponseNoCode:
            return "authorization response does not include a code"
        case .tokenRequestFailed(let error):
            return "token request failed: \(error.localizedDescription)"
        case .tokenResponseNoData:
            return "no data received as part of token response"
        case .tokenResponseInvalidData(let reason):
            return "invalid data received as part of token response: \(reason)"
        }
    }
}
