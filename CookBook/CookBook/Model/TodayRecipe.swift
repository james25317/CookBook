//
//  Video.swift
//  CookBook
//
//  Created by James Hung on 2021/5/30.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct TodayRecipe: Identifiable, Codable {

    @DocumentID public var id: String?
    var videoId: String

    enum CodingKeys: String, CodingKey {
        case videoId
    }

    var toDict: [String: Any] {
        return [
            "videoId": videoId as Any
        ]
    }
}
