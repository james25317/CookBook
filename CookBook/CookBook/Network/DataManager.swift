//
//  DataManager.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// What's this?
enum FirebaseError: Error {
    case documentError
}

// What's this?
enum MainError: Error {
    case youKnowNothingError(String)
}

class DataManager {
    static let shared = DataManager()

    lazy var db = Firestore.firestore()

    func fetchFeeds(completion: @escaping (Result<[Feed], Error>) -> Void) {

        db.collection("Feed")
            .order(by: "createdTime", descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var feeds: [Feed] = []

                    for document in querySnapshot!.documents {

                        print("\(document.documentID) => \(document.data())")

                        do {

                            if let feed = try document.data(as: Feed.self, decoder: Firestore.Decoder()) {
                                feeds.append(feed)
                            }

                        } catch {

                            completion(.failure(error))
                            // completion(.failure(FirebaseError.documentError))

                        }
                    }

                    // 獲取資料成功，escaping completion
                    completion(.success(feeds))
                }
            }
    }
}
