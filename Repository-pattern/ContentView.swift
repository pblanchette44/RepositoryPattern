//
//  ContentView.swift
//  Repository-pattern
//
//  Created by Philippe Blanchette on 2025-05-04.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel = ContentViewModel(
        service: NetworkPersonService(
            repo: PersonFactory()
        )
    )
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Button(action: {
                Task {
                    await viewModel.fetchPerson()
                }
            }, label: {
                Text("Press me to fetch data")
            })
            
            displayPerson(person: viewModel.person)
        }
        .padding()
    }
    
    @ViewBuilder
    func displayPerson(person: PersonModel?) -> some View {
        if let person {
            VStack {
                
                HStack {
                    Text("Name:")
                    Text(person.displayName)
                }
                
                HStack {
                    Text("Age:")
                    Text(person.age)
                }
                
                HStack {
                    Text("Country:")
                    Text(person.country)
                }
            }
        } else {
            EmptyView()
        }
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var person: PersonModel? = nil
    
    private var service: any PersonService
    
    init(service: any PersonService) {
        self.service = service
    }
    
    @MainActor
    func fetchPerson() async {
        self.person = try? await service.fetchPerson()
    }
}

struct PersonModel: Decodable {
    let displayName: String
    let country: String
    var age: String
}
