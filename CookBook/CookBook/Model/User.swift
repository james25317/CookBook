//
//  User.swift
//  CookBook
//
//  Created by James Hung on 2021/5/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Equatable {

    // Note: DocumentId = Fbuid
    @DocumentID public var id: String?
    var name: String
    var portrait: String
    var email: String
    var challengesCounts: Int
    var favoritesCounts: Int
    var recipesCounts: Int
    var blockList: [String]

    enum CodingKeys: String, CodingKey {
        case email,
            challengesCounts,
            favoritesCounts,
            name,
            portrait,
            recipesCounts,
            blockList
    }

    static func == (currentValue: User, newValue: User) -> Bool {

        guard currentValue.id == newValue.id,
              currentValue.name == newValue.name,
              currentValue.portrait == newValue.portrait,
              currentValue.email == newValue.email,
              currentValue.challengesCounts == newValue.challengesCounts,
              currentValue.favoritesCounts == newValue.favoritesCounts,
              currentValue.recipesCounts == newValue.recipesCounts,
              currentValue.blockList == newValue.blockList else { return false }

        return true
    }
}
