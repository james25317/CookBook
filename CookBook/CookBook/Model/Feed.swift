//
//  Feed.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Feed: Identifiable, Codable {

    @DocumentID public var id: String?
    var challenger: String
    var challengerRecipeId: String
    var challengerRecipeName: String
    var challengerRecipeMainImage: String
    var createdTime: Int64
    var isChallenged: Bool
    var mainImage: String
    var name: String
    var ownerId: String
    var portrait: String
    var recipeId: String
    var recipeName: String

    var toDict: [String: Any] {
        return [
            "challenger": challenger as Any,
            "challengerRecipeId": challengerRecipeId as Any,
            "challengerRecipeName": challengerRecipeName as Any,
            "challengerRecipeMainImage": challengerRecipeMainImage as Any,
            "createdTime": createdTime as Any,
            "isChallenged": isChallenged as Any,
            "mainImage": mainImage as Any,
            "name": name as Any,
            "ownerId": ownerId as Any,
            "portrait": portrait as Any,
            "recipeId": recipeId as Any,
            "recipeName": recipeName as Any
        ]
    }
}
