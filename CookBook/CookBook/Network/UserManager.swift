//
//  UserManger.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {

    static let shared = UserManager()

    lazy var fireStoreDB = Firestore.firestore()

    var uid = ""
    
    // init user
    var user = User(
        id: "",
        name: "CookBookUser",
        portrait: "",
        email: "",
        challengesCounts: 0,
        favoritesCounts: 0,
        recipesCounts: 0,
        blockList: []
    )

    // MARK: - User (Fetch)
    func fetchUserData(uid: String, completion: @escaping (Result<User, Error>) -> Void) {

        fireStoreDB.collection(Collections.user.rawValue)
            .document(uid)
            .addSnapshotListener { documentSnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    guard let document = documentSnapshot else { return }

                    do {

                        if let user = try document.data(as: User.self) {
                            
                            completion(.success(user))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            }
    }

    // MARK: - User (Add)
    func createUser(user: User, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        // create new UserData (documentId = ownerId (Fbuid))
        let ref = fireStoreDB.collection(Collections.user.rawValue).document(uid)

        try? ref.setData(from: user) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(ref.documentID))
            }
        }
    }

    // MARK: - User RecipesCounts (update)
    func increaseRecipesCounts(uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.user.rawValue).document(uid)

        ref.updateData(
            ["recipesCounts": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(uid))
            }
        }
    }

    // MARK: - User FavoritesCounts (update)
    func increaseFavoritesCounts(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.user.rawValue).document(documentId)

        ref.updateData(
            ["favoritesCounts": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - FavoritesCounts (update)
    func decreaseFavoritesCounts(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let ref = fireStoreDB.collection(Collections.user.rawValue).document(documentId)

        ref.updateData(
            ["favoritesCounts": FieldValue.increment(Int64(-1))]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }
    
    // MARK: - User ChallengesCounts (update)
    func updateChallengesCounts(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let ref = fireStoreDB.collection(Collections.user.rawValue).document(uid)

        ref.updateData(
            ["challengesCounts": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                print("Error increase challengesCounts: \(error)")

                completion(.failure(error))

            } else {

                print("\(uid): ChallengesCounts successfully increased!")

                completion(.success(uid))
            }
        }
    }

    // MARK: - Recipe Likes (increase)
    func increaseLikes(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["likes": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - Recipe Likes (decrease)
    func decreaseLikes(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["likes": FieldValue.increment(Int64(-1))]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - User BlockList (update)
    func updateBlockList(uid: String, recipeId: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.user.rawValue).document(uid)

        ref.updateData(
            ["blockList": FieldValue.arrayUnion([recipeId])]
        ) { error in

            if let error = error {

                print("Error update blockList: \(error)")

                completion(.failure(error))

            } else {

                print("RecipeId \(recipeId) update to User: \(uid) blockList successfully")

                completion(.success(recipeId))
            }
        }
    }
}
