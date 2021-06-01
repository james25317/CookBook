//
//  User.swift
//  CookBook
//
//  Created by James Hung on 2021/5/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {

    @DocumentID public var id: String?
    var appleId: String
    var name: String
    var portrait: String
    var email: String
    var challengesCounts: Int
    var favoritesCounts: Int
    var recipesCounts: Int

    enum CodingKeys: String, CodingKey {
        case appleId,
             email,
             challengesCounts,
             favoritesCounts,
             name,
             portrait,
             recipesCounts
    }
}
