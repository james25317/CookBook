//
//  Recipe.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Recipe: Identifiable, Codable {

    @DocumentID public var id: String?
    var createdTime: Timestamp
    var description: String
    var favoritesUserId: [String]
    var ingredients: [Ingredient]
    var isEditDone: Bool
    var likedUserId: [String]
    var likes: Int
    var mainImage: String
    var name: String
    var owner: String
    var steps: [Step]

    enum CodingKeys: String, CodingKey {
        case createdTime,
             description,
             favoritesUserId,
             ingredients,
             isEditDone,
             likedUserId,
             likes,
             mainImage,
             name,
             owner,
             steps
    }

    var toDict: [String: Any] {
        return [
            "createdTime": createdTime as Any,
            "description": description as Any,
            "favoritesUserId": favoritesUserId as Any,
            "ingredients": ingredients as Any,
            "isEditDone": isEditDone as Any,
            "likedUserId": likedUserId as Any,
            "likes": likes as Any,
            "mainImage": mainImage as Any,
            "name": name as Any,
            "owner": owner as Any,
            "steps": steps as Any
        ]
    }

}
