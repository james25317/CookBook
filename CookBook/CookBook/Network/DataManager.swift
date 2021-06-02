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

    // MARK: Feeds
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
                        }
                    }

                    // 獲取資料成功，escaping completion
                    completion(.success(feeds))
                }
            }
    }

    // MARK: User
//    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
//
//        // 可以用 where 篩出 appleId
//
//        db.collection(Collections.user.rawValue)
//            .document("SADUxqR04ihqg1XUgDHn")
//            .addSnapshotListener({ documentSnapshot, error in
//                if let error = error {
//
//                    completion(.failure(error))
//                } else {
//
//                    guard let document = documentSnapshot else { return }
//
//                    do {
//
//                        if let user = try document.data(as: User.self) {
//
//                            completion(.success(user))
//                        }
//                    } catch {
//
//                        completion(.failure(error))
//                    }
//                }
//            })
//    }

    // MARK: Recipes
    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
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

    // MARK: Recipes (by ownerId)
    func fetchOwnerRecipes(ownerId: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
            .whereField(Field.owner.rawValue, isEqualTo: ownerId)
            .order(by: Field.time.rawValue, descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var recipes: [Recipe] = []

                    guard let querySnapshot = querySnapshot else { return }

                    for document in querySnapshot.documents {

                        print("\(document.documentID) => \(document.data())")

                        do {

                            if var recipe = try document.data(as: Recipe.self) {

                                // assign documentId to each recipe
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

    // MARK: Recipes (by favoritesUserId)
    func fetchFavoritesRecipes(ownerId: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
            .whereField(Field.favorites.rawValue, arrayContains: ownerId)
            .order(by: Field.time.rawValue, descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var recipes: [Recipe] = []

                    guard let querySnapshot = querySnapshot else { return }

                    for document in querySnapshot.documents {

                        print("\(document.documentID) => \(document.data())")

                        do {

                            if var recipe = try document.data(as: Recipe.self) {

                                // assign documentId to each recipe
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

    // MARK: Recipes (by challenger)
    func fetchChallengesRecipes(ownerId: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
            .whereField(Field.challenges.rawValue, isEqualTo: ownerId)
            .order(by: Field.time.rawValue, descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var recipes: [Recipe] = []

                    guard let querySnapshot = querySnapshot else { return }

                    for document in querySnapshot.documents {

                        print("\(document.documentID) => \(document.data())")

                        do {

                            if var recipe = try document.data(as: Recipe.self) {

                                // assign documentId to each recipe
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

    // MARK: Recipe
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

                            // assign 
                            recipe.id = documentId

                            completion(.success(recipe))
                        }
                    } catch {

                        completion(.failure(error))
                    }
                }
            })
    }

    // MARK: TodayRecipe
    func fetchTodayRecipe(completion: @escaping (Result<TodayRecipe, Error>) -> Void) {

        db.collection(Collections.today.rawValue)
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

    // MARK: OfficialRecipe (Query)
    func fetchOfficialRecipe(completion: @escaping (Result<Recipe, Error>) -> Void) {

        db.collection(Collections.recipe.rawValue)
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

    // MARK: Ingredients (update)
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

    // MARK: Steps (update)
    func updateSteps(documentId: String, steps: [Step], completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) Step 欄位
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

    // MARK: MainImage (update)
    func updateMainImage(documentId: String, mainImage: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) MainImage 欄位
        let ref = db.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: RecipesCounts (update)
    func updateRecipesCounts(userDocumentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = db.collection(Collections.user.rawValue).document(userDocumentId)

        ref.updateData(
            ["recipesCounts": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                print("Error increase recipesCounts: \(error)")

                completion(.failure(error))

            } else {

                print("\(userDocumentId): RecipesCounts successfully increased!")

                completion(.success(userDocumentId))
            }
        }
    }

    // MARK: FavoritesCounts (update)
    func updateFavoritesCounts(userDocumentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = db.collection(Collections.user.rawValue).document(userDocumentId)

        ref.updateData(
            ["favoritesCounts": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                print("Error increase favoritesCounts: \(error)")

                completion(.failure(error))

            } else {

                print("\(userDocumentId): FavoritesCounts successfully increased!")

                completion(.success(userDocumentId))
            }
        }
    }

    // MARK: Likes (update)
    func updateLikes(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = db.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["likes": FieldValue.increment(Int64(1))]
        ) { error in

            if let error = error {

                print("Error increase likes: \(error)")

                completion(.failure(error))

            } else {

                print("\(documentId): Likes successfully increased!")

                completion(.success(documentId))
            }
        }
    }

    // MARK: FavoritesUserId (update)
    func updatefavoritesUserId(documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 favoritesUserId 欄位
        let ref = db.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(
            ["favoritesUserId": FieldValue.arrayUnion([favoritesUserId])]
        ) { error in

            if let error = error {

                print("Error update favoritesUserId: \(error)")

                completion(.failure(error))

            } else {

                print("\(documentId): favoritesUserId successfully updated!")

                completion(.success(documentId))
            }
        }
    }

    // MARK: Recipe (Add)
    func createRecipe(recipe: inout Recipe, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = db.collection(Collections.recipe.rawValue).document()

        // inout 屬性讓可以先 assign
        recipe.id = ref.documentID

        // 寫入該帳號使用者的 Id (Fbuid)
        recipe.ownerId = uid

        try? ref.setData(from: recipe) { error in

            if let error = error {

                // print("Error adding document: \(error)")

                completion(.failure(error))
            } else {

                // print("Document added with ID: \(String(describing: ref.documentID))")

                // 回傳新產生的 DocumentId
                completion(.success(ref.documentID))
            }
        }
    }

    // MARK: Feed (Add)
    func createFeed(feed: inout Feed, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = db.collection(Collections.feed.rawValue).document()

        // inout 屬性讓可以先 assign
        feed.id = ref.documentID

        try? ref.setData(from: feed) { error in

            if let error = error {

                // print("Error adding document: \(error)")

                completion(.failure(error))
            } else {

                // print("Document added with ID: \(String(describing: ref.documentID))")

                // 回傳新產生的 DocumentId
                completion(.success(ref.documentID))
            }
        }
    }
}
