//
//  CategoryData.swift
//  HypnoLoopsRecordTest2
//
//  Created by Joey Rubin on 10/1/23.
//

import Foundation
import Combine

class Affirmation: Identifiable, ObservableObject, Decodable {
    let id: String
    let affirmation: String
    @Published var liked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, affirmation, liked
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        affirmation = try container.decode(String.self, forKey: .affirmation)
        liked = try container.decode(Bool.self, forKey: .liked)
    }
    
    // You may want to add a convenience initializer as well, for manual object creation.
    init(id: String, affirmation: String, liked: Bool) {
        self.id = id
        self.affirmation = affirmation
        self.liked = liked
    }
}



struct Category: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let affirmations: [Affirmation]
}

struct Categories: Decodable {
    let categories: [Category]
}
