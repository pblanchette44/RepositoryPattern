//
//  RepositoryProtocol.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-05.
//

import Foundation

protocol RepositoryNetwork {
    associatedtype DTO: Decodable
    associatedtype RepositoryErrorType: Error
    
    var request: URLRequest { get }
    func fetchData() async throws -> Data
    func decode(_ data: Data) throws -> DTO
}

enum RepositoryError: Error {
    case networkError
    case decodingError
    case transformError
    case internalError
}

extension RepositoryNetwork {
    typealias RepositoryErrorType = RepositoryError
}
