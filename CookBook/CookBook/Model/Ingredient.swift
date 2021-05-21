//
//  Ingredient.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Ingredient: Codable {

    var amount: Int
    var name: String
    var unit: String

    enum CodingKeys: String, CodingKey {
        case amount, name, unit
    }

    var toDict: [String: Any] {
        return [
            "amount": amount as Any,
            "name": name as Any,
            "unit": unit as Any
        ]
    }
}
