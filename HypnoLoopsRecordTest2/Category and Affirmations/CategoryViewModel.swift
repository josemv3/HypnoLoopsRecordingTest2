//
//  CategoryViewModel.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    var likedAffirmations: [Affirmation] {
        return categories.flatMap { $0.affirmations.filter { $0.liked } }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var likedAffirmationsFilePath: URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent("likedAffirmations.plist")
    }

    init() {
        load()
        loadLikedAffirmations()
    }

    func load() {
        if let fileLocation = Bundle.main.url(forResource: "Affirmations", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode(Categories.self, from: data)
                self.categories = dataFromJson.categories
                
                // Subscribe to changes in the liked property of all affirmations
                for category in categories {
                            for affirmation in category.affirmations {
                                affirmation.objectWillChange.sink(receiveValue: { [weak self] _ in
                                    print("ViewModel received an update from an affirmation")
                                    self?.objectWillChange.send()
                                })
                                .store(in: &cancellables)  // Store the subscription
                            }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func saveLikedAffirmations() {
            guard let filePath = likedAffirmationsFilePath else { return }
            let likedAffirmationIds = categories.flatMap { $0.affirmations }.filter { $0.liked }.map { $0.id }
            
            do {
                let data = try PropertyListEncoder().encode(likedAffirmationIds)
                try data.write(to: filePath)
            } catch {
                print("Could not save liked affirmations: \(error)")
            }
        }
        
        func loadLikedAffirmations() {
            guard let filePath = likedAffirmationsFilePath else { return }
            guard let data = try? Data(contentsOf: filePath) else { return }
            
            do {
                let likedAffirmationIds = try PropertyListDecoder().decode([String].self, from: data)
                for category in categories {
                    for affirmation in category.affirmations {
                        affirmation.liked = likedAffirmationIds.contains(affirmation.id)
                    }
                }
            } catch {
                print("Could not load liked affirmations: \(error)")
            }
        }
}

