//
//  PersonRepoFactory.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-05.
//

import Foundation

/*
    Repository
*/
protocol RepoFactory {
    associatedtype RepositoryType
    func initRepository(_ factory: PersonFactory.FactoryType) -> RepositoryType
}

protocol PersonRepository {
    func fetchPersonData() async throws -> PersonModel
}

class PersonFactory: RepoFactory {
    enum FactoryType {
        case mock
        case remote
        case fakeApi
        case temp
    }
    
    typealias RepositoryType = any PersonRepository
    
    func initRepository(_ factory: FactoryType) -> any PersonRepository {
        switch factory {
        case .mock, .temp:
            MockPersonRepository()
        case .remote:
            RemotePersonRepository()
        case .fakeApi:
            FakeApiPersonRepository()
        }
    }
}
