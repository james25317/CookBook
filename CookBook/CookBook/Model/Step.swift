//
//  Step.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation

struct Step: Codable {

    var description: String
    var image: String

    enum CodingKeys: String, CodingKey {
        case description, image
    }

    var toDict: [String: Any] {
        return [
            "description": description as Any,
            "image": image as Any
        ]
    }
}
