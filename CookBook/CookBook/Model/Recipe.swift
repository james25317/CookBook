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
    var likes: Int64
    var mainImage: String
    var name: String
    var ownerId: String
    var steps: [Step]
    var challenger: String

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
             ownerId,
             steps,
             challenger
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
            "ownerId": ownerId as Any,
            "steps": steps as Any,
            "challenger": challenger as Any
        ]
    }

}
