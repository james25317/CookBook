//
//  RecipeManager.swift
//  CookBook
//
//  Created by James Hung on 2021/6/17.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipeManager {

    static let shared = RecipeManager()

    lazy var fireStoreDB = Firestore.firestore()
    
    // MARK: - Recipes
    func fetchRecipesData(completion: @escaping (Result<[Recipe], Error>) -> Void) {

        fireStoreDB.collection(Collections.recipe.rawValue)
            .order(by: "createdTime", descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var recipes: [Recipe] = []

                    guard let querySnapshot = querySnapshot else { return }

                    for document in querySnapshot.documents {

                        print("\(document.documentID) => \(document.data())")

                        do {

                            if var recipe = try document.data(as: Recipe.self, decoder: Firestore.Decoder()) {

                                recipe.id = document.documentID

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

    // MARK: - Recipe (snapshotListener)
    func fetchRecipeData(documentId: String, completion: @escaping (Result<Recipe, Error>) -> Void) {

        fireStoreDB.collection(Collections.recipe.rawValue)
            .document(documentId)
            .addSnapshotListener { documentSnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    guard let document = documentSnapshot else { return }

                    do {

                        if var recipe = try document.data(as: Recipe.self) {

                            // assign documentId
                            recipe.id = documentId

                            completion(.success(recipe))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            }
    }

    // MARK: - TodayRecipe
    func fetchTodayRecipeData(completion: @escaping (Result<TodayRecipe, Error>) -> Void) {

        fireStoreDB.collection(Collections.today.rawValue)
            .document(Document.todayRecipe.rawValue)
            .addSnapshotListener { documentSnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    guard let document = documentSnapshot else { return }

                    do {

                        if var todayRecipe = try document.data(as: TodayRecipe.self) {

                            todayRecipe.id = document.documentID

                            completion(.success(todayRecipe))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            }
    }
    
    // MARK: - Recipe (by challenge status)
    func checkRecipeChallenger(documentId: String, completion: @escaping (Result<Recipe, Error>) -> Void) {

        fireStoreDB.collection(Collections.recipe.rawValue)
            .document(documentId)
            .getDocument { documentSnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    guard let document = documentSnapshot else { return }

                    do {

                        if let recipe = try document.data(as: Recipe.self) {

                            completion(.success(recipe))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            }
    }

    // MARK: - OfficialRecipe (Query)
    func fetchOfficialRecipeData(completion: @escaping (Result<Recipe, Error>) -> Void) {

        fireStoreDB.collection(Collections.recipe.rawValue)
            .whereField("ownerId", isEqualTo: "official")
            .getDocuments { querySnapshot, error in

                if let error = error {

                    print("Error getting documents: \(error)")

                    completion(.failure(error))
                } else {

                    guard let querySnapshot = querySnapshot else { return }

                    for document in querySnapshot.documents {

                        print("\(document.documentID) => \(document.data())")

                    }

                    do {

                        // there is only one "official" recipe
                        if var officialRecipe = try querySnapshot.documents.first?.data(as: Recipe.self) {

                            officialRecipe.id = querySnapshot.documents.first?.documentID

                            completion(.success(officialRecipe))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            }
    }
    
    // MARK: - Recipe Likes (increase)
    func updateLikes(documentId: String, number: Int, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["likes": FieldValue.increment(Int64(number))]
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

    // MARK: - Recipe FavoritesUserId (update)
    func addfavoritesUserId(documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["favoritesUserId": FieldValue.arrayUnion([favoritesUserId])]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - Recipe Ingredients (update)
    func uploadIngredientsData(documentId: String, ingredients: [Ingredient], completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: - Steps (update)
    func uploadStepsData(documentId: String, steps: [Step], completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

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
    
    // MARK: - Recipe FavoritesUserId (update)
    func removefavoritesUserId(documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["favoritesUserId": FieldValue.arrayRemove([favoritesUserId])]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }
    
    // MARK: - Recipe RecipeChallenger (update)
    func updateRecipeChallengeStatus(documentId: String, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["challenger": uid]
        ) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - Recipe IsEditDone (update)
    func updateIsEditDone(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(["isEditDone": true]) { error in

            if let error = error {

                completion(.failure(error))

            } else {

                completion(.success(documentId))
            }
        }
    }

    // MARK: - Recipe MainImage (update)
    func uploadMainImage(documentId: String, mainImage: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(["mainImage": mainImage]) { error in

            if let error = error {

                print("Error updating mainImage: \(error)")

                completion(.failure(error))

            } else {

                print("MainImage successfully updated")

                completion(.success(mainImage))
            }
        }
    }
    
    // MARK: - Recipe (Add)
    func createRecipeData(recipe: inout Recipe, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = fireStoreDB.collection(Collections.recipe.rawValue).document()

        recipe.id = ref.documentID

        recipe.ownerId = uid

        try? ref.setData(from: recipe) { error in

            if let error = error {

                completion(.failure(error))
            } else {

                completion(.success(ref.documentID))
            }
        }
    }

}
