//
//  DataManager.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum Collections: String {

    case feed = "Feed"

    case user = "User"

    case recipe = "Recipe"
}

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

        db.collection(Collections.feed.rawValue)
            .order(by: "createdTime", descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var feeds: [Feed] = []

                    guard let documents = querySnapshot?.documents else { return }

                    for document in documents {

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

    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {

        // 可以用 where 篩出 appleId

        db.collection(Collections.user.rawValue)
            .document("SADUxqR04ihqg1XUgDHn")
            .addSnapshotListener({ documentSnapshot, error in
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
            })
    }

    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
            .order(by: "createdTime", descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var recipes: [Recipe] = []

                    for document in querySnapshot!.documents {

                        print("\(document.documentID) => \(document.data())")

                        do {

                            if let recipe = try document.data(as: Recipe.self, decoder: Firestore.Decoder()) {
                                recipes.append(recipe)
                            }
                        } catch {

                            completion(.failure(error))
                        }
                    }

                    completion(.success(recipes))
                }
            }
    }

    func fetchRecipe(documentId: String, completion: @escaping (Result<Recipe, Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
            .document(documentId)
            .addSnapshotListener({ documentSnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    guard let document = documentSnapshot else { return }

                    do {

                        if var recipe = try document.data(as: Recipe.self) {

                            recipe.id = documentId

                            completion(.success(recipe))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            })
    }

    func updateIngredients(documentId: String, ingredients: [Ingredient], completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) Ingredient 欄位
        let ref = db.collection(Collections.recipe.rawValue).document(documentId)

        let dicArray = ingredients.compactMap { ingredient in

            ingredient.toDict
        }

        ref.updateData(["ingredients": dicArray]) { error in

            if let error = error {

                print("Error updating ingredients: \(error)")
            } else {

                print("Ingredients successfully updated")
            }
        }
    }

    func updateSteps(documentId: String, steps: [Step], completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) Ingredient 欄位
        let ref = db.collection(Collections.recipe.rawValue).document(documentId)

        let dicArray = steps.compactMap { step in

            step.toDict
        }

        ref.updateData(["steps": dicArray]) { error in

            if let error = error {

                print("Error updating steps: \(error)")
            } else {

                print("Steps successfully updated")
            }
        }
    }

    func createRecipe(recipe: inout Recipe, completion: @escaping (Result<String, Error>) -> Void) {

        var ref: DocumentReference?

        recipe.id = ref?.documentID

        ref = try? db.collection(Collections.recipe.rawValue).addDocument(from: recipe) { error in

            if let error = error {

                print("Error adding document: \(error)")

                completion(.failure(error))
            } else {

                print("Document added with ID: \(String(describing: ref!.documentID))")

                // 回傳產生的 DocumentId
                completion(.success(ref!.documentID))
            }
        }
    }
}
