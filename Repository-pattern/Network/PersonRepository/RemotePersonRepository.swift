//
//  RemotePersonRepository.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-05.
//

import Foundation

extension PersonFactory {
    class RemotePersonRepository: RepositoryNetwork {

        typealias DTO = UserDTO
        
        struct UserDTO: Decodable {
            let age: Int
            let firstName: String
            let lastName: String
            let address: AddressDTO
            
            struct AddressDTO: Decodable {
                let country: String
            }
        }
        
        var request: URLRequest {
            guard let url = URL(string: "https://dummyjson.com/users/1") else {
                fatalError()
            }
            
            let urlRequest = URLRequest(url: url)
            
            return urlRequest
        }

        func fetchData() async throws -> Data {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                return data
            } catch {
                throw RepositoryError.networkError
            }
        }
        
        func decode(_ data: Data) throws -> DTO {
            do {
                return try JSONDecoder().decode(UserDTO.self, from: data)
            } catch {
                throw RepositoryError.decodingError
            }

        }
    }
}


extension PersonFactory.RemotePersonRepository: PersonRepository {
    func fetchPersonData() async throws -> PersonModel {
        do {
            let dto = try await decode(fetchData())
            
            return PersonModel.init(displayName: "\(dto.firstName) \(dto.lastName)", country: dto.address.country, age: "\(dto.age)")
        }
    }
}

