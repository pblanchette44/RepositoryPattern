//
//  FakeApiPersonRepository.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-05.
//

import Foundation

extension PersonFactory {
    class FakeApiPersonRepository: RepositoryNetwork {
        typealias DTO = DataDTO
        
        struct DataDTO: Decodable {
            let data: [UserDTO]
        }
        
        struct UserDTO: Decodable {
            let birthday: String
            let firstName: String
            let lastName: String
            let address: AddressDTO
            
            struct AddressDTO: Decodable {
                let country: String
            }
            
            enum CodingKeys: String, CodingKey {
                case birthday
                case firstName = "firstname"
                case lastName = "lastname"
                case address
            }
        }
        
        var request: URLRequest {
            guard let url = URL(string: "https://fakerapi.it/api/v1/persons?_quantity=1") else {
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
                return try JSONDecoder().decode(DTO.self, from: data)
            } catch {
                throw RepositoryError.decodingError
            }

        }
    }
}

extension PersonFactory.FakeApiPersonRepository : PersonRepository {
    func fetchPersonData() async throws -> PersonModel {
        
        func parseYear(fromString date: String) -> Int? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            
            guard let birthday = dateFormatter.date(from: date) else {
                return nil
            }

            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year], from: birthday, to: now)
            
            guard let y = components.year else {
                return nil
            }
            
            return y
        }
        
        do {
            
            guard let dto = try await decode(fetchData()).data.first else {
                throw RepositoryError.transformError
            }
            
            let age = String("\(parseYear(fromString: dto.birthday) ?? 0)")
            
            return PersonModel.init(
                displayName: "\(dto.firstName) \(dto.lastName)",
                country: dto.address.country,
                age: age
            )
            
        } catch {
            throw RepositoryError.transformError
        }
    }
}

