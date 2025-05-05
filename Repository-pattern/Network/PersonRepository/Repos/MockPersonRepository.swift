//
//  MockPersonRepository.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-05.
//

import Foundation

extension PersonFactory {
    /* Mocked version */
    class MockPersonRepository: PersonRepository {
        func fetchPersonData() -> PersonModel {
            .init(
                displayName: "Mr Charles Burger",
                country: "America",
                age: "14"
            )
        }
    }
}
