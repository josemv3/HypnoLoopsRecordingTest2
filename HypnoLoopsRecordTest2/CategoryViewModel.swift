//
//  CategoryViewModel.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    var likedAffirmations: [Affirmation] {
           return categories.flatMap { $0.affirmations.filter { $0.liked } }
       }

    init() {
        load()
    }

    func load() {
        if let fileLocation = Bundle.main.url(forResource: "Affirmations", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode(Categories.self, from: data)
                self.categories = dataFromJson.categories
            } catch {
                print(error)
            }
        }
    }
    
}
