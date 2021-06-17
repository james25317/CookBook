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

class DataManager {

    static let shared = DataManager()

    lazy var firestoreDB = Firestore.firestore()

    // MARK: - Feeds (fetch)
    func fetchFeeds(completion: @escaping (Result<[Feed], Error>) -> Void) {

        firestoreDB.collection(Collections.feed.rawValue)
            .order(by: Field.time.rawValue, descending: true)
            .getDocuments { querySnapshot, error in

                if let error = error {

                    completion(.failure(error))
                } else {

                    var feeds: [Feed] = []

                    guard let documents = querySnapshot?.documents else { return }

                    for document in documents {

                        // print("\(document.documentID) => \(document.data())")

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
    
    // MARK: - Recipes
    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {

        firestoreDB.collection(Collections.recipe.rawValue)
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

    // MARK: - Recipes (by ownerId)
    func fetchOwnerRecipes(ownerId: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {

        firestoreDB.collection(Collections.recipe.rawValue)
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

    // MARK: - Recipes (by favoritesUserId)
    func fetchFavoritesRecipes(uid: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {

        firestoreDB.collection(Collections.recipe.rawValue)
            .whereField(Field.favorites.rawValue, arrayContains: uid)
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

        firestoreDB.collection(Collections.recipe.rawValue)
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

    // MARK: - Recipe (by challenge status)
    func checkRecipeChallenger(documentId: String, completion: @escaping (Result<Recipe, Error>) -> Void) {

        firestoreDB.collection(Collections.recipe.rawValue)
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

    // MARK: - Recipe (snapshotListener)
    func fetchRecipeData(documentId: String, completion: @escaping (Result<Recipe, Error>) -> Void) {

        firestoreDB.collection(Collections.recipe.rawValue)
            .document(documentId)
            .addSnapshotListener { documentSnapshot, error in

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
            }
    }

    // MARK: TodayRecipe
    func fetchTodayRecipe(completion: @escaping (Result<TodayRecipe, Error>) -> Void) {

        firestoreDB.collection(Collections.today.rawValue)
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

        firestoreDB.collection(Collections.recipe.rawValue)
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

    // MARK: - Ingredients (update)
    func uploadIngredientsData(documentId: String, ingredients: [Ingredient], completion: @escaping (Result<String, Error>) -> Void) {
        
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

        // 這邊寫更新(覆寫) Step 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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
    func uploadMainImage(documentId: String, mainImage: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) MainImage 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: IsEditDone (update)
    func updateIsEditDone(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新(覆寫) MainImage 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

        ref.updateData(["isEditDone": true]) { error in

            if let error = error {

                completion(.failure(error))

            } else {
                
                completion(.success(documentId))
            }
        }
    }

    // MARK: - RecipesCounts (update)
    func increaseRecipesCounts(uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = firestoreDB.collection(Collections.user.rawValue).document(uid)

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

    // MARK: - FavoritesCounts (update)
    func increaseFavoritesCounts(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = firestoreDB.collection(Collections.user.rawValue).document(documentId)

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

    // MARK: FavoritesCounts (update)
    func decreaseFavoritesCounts(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = firestoreDB.collection(Collections.user.rawValue).document(documentId)

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

    // MARK: ChallengesCounts (update)
    func updateChallengesCounts(uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 ChallengesCounts 欄位
        let ref = firestoreDB.collection(Collections.user.rawValue).document(uid)

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

    // MARK: Likes (update)
    func increaseLikes(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: Likes (update)
    func decreaseLikes(documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 likes 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: FavoritesUserId (update)
    func addfavoritesUserId(documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 favoritesUserId 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: FavoritesUserId (update)
    func removefavoritesUserId(documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 favoritesUserId 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: BlockList (update)
    func updateBlockList(uid: String, recipeId: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 favoritesUserId 欄位
        let ref = firestoreDB.collection(Collections.user.rawValue).document(uid)

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

    // MARK: FeedChallenger (update)
    func updateFeedChallengeStatus(documentId: String, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = firestoreDB.collection(Collections.feed.rawValue).document(documentId)

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

    // MARK: FeedChallengeDone (update)
    func updateChallengeStatus(documentId: String, recipeId: String, mainImage: String, recipeName: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 Challenger, isChallenged 欄位
        let ref = firestoreDB.collection(Collections.feed.rawValue).document(documentId)

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

    // MARK: RecipeChallenger (update)
    func updateRecipeChallengeStatus(documentId: String, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        // 這邊寫更新 Challenger 欄位
        let ref = firestoreDB.collection(Collections.recipe.rawValue).document(documentId)

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

    // MARK: - Recipe (Add)
    func createRecipeData(recipe: inout Recipe, uid: String, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = firestoreDB.collection(Collections.recipe.rawValue).document()

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

    // MARK: - Feed (Add)
    func createFeedData(feed: inout Feed, completion: @escaping (Result<String, Error>) -> Void) {

        let ref = firestoreDB.collection(Collections.feed.rawValue).document()

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
