//
//  DataManager.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Collections: String {

    case feed = "Feed"

    case user = "User"

    case recipe = "Recipe"

    case today = "Today"
}

enum Document: String {

    case todayRecipe = "TodayRecipe"
}

enum Field: String {

    case owner = "ownerId"

    case favorites = "favoritesUserId"

    case challenges = "challenger"

    case challenged = "isChallenged"

    case liked = "likedUserId"

    case edit = "isEditDone"

    case time = "createdTime"

    case id = "uid"
}

class FeedManager {

    static let shared = FeedManager()

    lazy var fireStoreDB = Firestore.firestore()

    // MARK: - Feeds (fetch)
    func fetchFeeds(completion: @escaping (Result<[Feed], Error>) -> Void) {

        fireStoreDB.collection(Collections.feed.rawValue)
            .order(by: Field.time.rawValue, descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var feeds: [Feed] = []

                    guard let documents = querySnapshot?.documents else { return }

                    for document in documents {

                        do {

                            if let feed = try document.data(as: Feed.self, decoder: Firestore.Decoder()) {
                                feeds.append(feed)
                            }

                        } catch {

                            completion(.failure(error))
                        }
                    }

                    completion(.success(feeds))
                }
            }
    }
    
    // MARK: - Feed Challenger (update)
    func updateFeedChallengeStatus(documentId: String, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.feed.rawValue).document(documentId)

        ref.updateData(
            ["challenger": uid, "isChallenged": true]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - Feed ChallengeDone (update)
    func updateChallengeStatus(documentId: String, recipeId: String, mainImage: String, recipeName: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.feed.rawValue).document(documentId)

        ref.updateData(
            ["challengerRecipeId": recipeId, "challengerRecipeMainImage": mainImage, "challengerRecipeName": recipeName]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }
    
    // MARK: - Feed (Add)
    func createFeedData(feed: inout Feed, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.feed.rawValue).document()

        // assign documentId (&inout)
        feed.id = ref.documentID

        try? ref.setData(from: feed) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(ref.documentID))
            }
        }
    }
}
