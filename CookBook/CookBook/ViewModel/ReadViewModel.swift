//
//  ReadViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/27.
//

import Foundation
import Firebase

class ReadViewModel {

    let recipeViewModel: Box<RecipeViewModel?> = Box(nil)

    var recipeId: String?

    var selectedFeed: Feed?

    var onDenied: (() -> Void)?

    var onReturned: (() -> Void)?

    var onGranteed: (() -> Void)?

    var onRefreshed: (() -> Void)?
    
    func fetchRecipe(reciepeId: String, completion: @escaping (Result<Recipe, Error>) -> Void = { _ in }) {

        DataManager.shared.fetchRecipe(documentId: reciepeId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success!")

                // 回傳的 Recipe 至 Box<RecipeViewModel?> 監聽
                self?.recipeViewModel.value = RecipeViewModel(model: recipe)

                completion(.success(recipe))

            case .failure(let error):

                print("Fetch failure: \(error)")

                completion(.failure(error))
            }
        }
    }

    func checkRecipeValue(reciepeId: String) {

        DataManager.shared.checkRecipe(documentId: reciepeId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Check recipe success!")

                if !recipe.challenger.isEmpty {

                    print("Challenger is not empty")
                    // challenger 已經有值:
                    // 顯示提示＆返回主頁

                    // 提示彈窗
                    self?.onDenied?()

                    // 返回主頁
                    self?.onReturned?()
                } else {

                    print("Challenger is empty")
                    // challenger 無值:
                    // 1. 更新 uid 為 challenger (Feed & Recipe)
                    // 2. 更新 isChallenged = true
                    // 3. create Recipe

                    self?.onGranteed?()
                }

            case .failure(let error):

                print("Fetch failure: \(error)")
            }
        }
    }

    func updateLikes(with documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        DataManager.shared.updateLikes(documentId: documentId) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): Likes increase 1")

                completion(.success(documentId))

            case .failure(let error):

                print(error)

                completion(.failure(error))
            }
            
        }
    }

    func updateFavoritesCounts(uid: String) {

        DataManager.shared.updateFavoritesCounts(uid: uid) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FavoritesCounts increase 1")

            case .failure(let error):

                print(error)
            }

        }
    }

    func updateFavoritesUserId(recipeId documentId: String, uid favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        DataManager.shared.updatefavoritesUserId(
            documentId: documentId,
            favoritesUserId: favoritesUserId) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): \(favoritesUserId) added")

                completion(.success(documentId))

            case .failure(let error):

                print(error)

                completion(.failure(error))
            }

        }
    }

    func updateFeedStatus(feedId documentId: String, uid: String) {

        DataManager.shared.updateFeedChallengeStatus(
            documentId: documentId,
            uid: uid) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("Feed \(documentId): challenge status \(uid) updated")

            case .failure(let error):

                print(error)
            }
        }
    }

    func updateRecipeStatus(recipeId documentId: String, uid: String) {

        DataManager.shared.updateRecipeChallengeStatus(
            documentId: documentId,
            uid: uid) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("Recipe \(documentId): challenger \(uid) updated")

            case .failure(let error):

                print(error)
            }
        }
    }
}
