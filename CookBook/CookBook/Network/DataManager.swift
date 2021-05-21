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

    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {

        db.collection("Recipe")
            .order(by: "createdTime", descending: true)
            .getDocuments() { (querySnapshot, error) in

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
                            // completion(.failure(FirebaseError.documentError))
                        }
                    }

                    completion(.success(recipes))
                }
            }
    }

    func updateIngredient(ingredients: inout [Ingredient], completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) Ingredient 欄位
        let ref = db.collection("Recipe").document("w2Un7JQnj5q1zqbs0nHC")

        let dic = ingredients.compactMap { ingredient in

            ingredient.toDict
        }

        try? ref.updateData(["ingredients": dic]) { error in

            if let error = error {

                print("Error updating ingredients: \(error)")
            } else {

                print("Ingredients successfully updated")
            }
        }
    }

    func uploadRecipe(recipe: inout Recipe, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫上傳 (Create CookBook) Recipe 資料的部分
        var ref: DocumentReference?

        recipe.id = ref?.documentID

        recipe.createdTime = Timestamp(date: Date())

        ref = try? db.collection("Recipe").addDocument(from: recipe) { error in

            if let error = error {

                print("Error adding document: \(error)")

                completion(.failure(error))
            } else {

                print("Document added with ID: \(ref!.documentID)")

                completion(.success("Upload Ingredient Success!"))
            }
        }
    }
}
