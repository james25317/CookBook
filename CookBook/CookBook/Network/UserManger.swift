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

    lazy var db = Firestore.firestore()

    var uid = ""

    // init user
    var user = User(
        id: "",
        name: "CookBookUser",
        portrait: "",
        email: "",
        challengesCounts: 0,
        favoritesCounts: 0,
        recipesCounts: 0
    )

    // MARK: User (Fetch)
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {

        db.collection(Collections.user.rawValue)
            .document(uid)
            .getDocument { documentSnapshot, error in

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

    // MARK: User (Add)
    func createUser(user: User, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 新創 documentId = ownerId (Fbuid) 的資料
        let ref = db.collection(Collections.user.rawValue).document(uid)

        try? ref.setData(from: user) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(ref.documentID))
            }
        }
    }
}
