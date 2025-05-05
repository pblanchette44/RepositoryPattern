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

// This is the public interface of the repository, this the sole point of coupling between repos and the exterior
protocol PersonRepository {
    /*
     
        There's 2 coupling element between the consumer of that api and the implementer
            - the function signature and inputs
            - the output model
     
        this means that any further Repo, would require that no params be provided, and that the output be a PersonModel
     
            - this is a potential pitfall, because without further abstracting at the service layer, the PersonModel risks being coupled to the whole app
                if it reaches the view.
     
     */
    func fetchPersonData() async throws -> PersonModel
}

class PersonFactory: RepoFactory {
    enum FactoryType {
        case mock
        case remote
        case fakeApi
    }
    
    typealias RepositoryType = any PersonRepository
    
    func initRepository(_ factory: FactoryType) -> any PersonRepository {
        switch factory {
        case .mock:
            MockPersonRepository()
        case .remote:
            RemotePersonRepository()
        case .fakeApi:
            FakeApiPersonRepository()
        }
    }
}
