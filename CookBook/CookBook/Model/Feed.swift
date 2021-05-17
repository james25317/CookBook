//
//  Feed.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation

struct Feed: Codable {

  var challenger: String
  var createdTime: Int64
  var id: String
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
      "createdTime": createdTime as Any,
      "id": id as Any,
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
