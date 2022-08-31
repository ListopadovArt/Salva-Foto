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
