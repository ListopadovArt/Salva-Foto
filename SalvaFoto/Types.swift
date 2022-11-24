//
//  Types.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 24.11.22.
//

import Foundation

public typealias GenericCompletionManager<T> = ((_ result: Result<T, NetworkError>) -> Void)
public typealias GenericCompletionAuthenticator<T> = ((_ result: Result<T, AuthenticatorError>) -> Void)


