//
//  PersonService.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-05.
//

import Foundation

/*
    Service
*/
protocol PersonService {
    func fetchPerson() async throws -> PersonModel
}

class NetworkPersonService: PersonService {
    
    private var repo: PersonFactory
    
    init(repo: PersonFactory) {
        self.repo = repo
    }
    
    func fetchPerson() async throws -> PersonModel {
        
        var person = try await repo.initRepository(.fakeApi).fetchPersonData()
        
        // from here we only do business transform...
        if let age = Int(person.age),
           //i.e: majority age can change from one country to the next for ex
           age < 18 {
            person.age = "Minor"
        }
        
        return person
    }
    
    func fetchCouple() async throws -> (PersonModel, PersonModel) {
        
        let (first, second) = (
            try await repo.initRepository(.mock).fetchPersonData(),
            try await repo.initRepository(.remote).fetchPersonData()
        )
        return (first, second)
    }
}

