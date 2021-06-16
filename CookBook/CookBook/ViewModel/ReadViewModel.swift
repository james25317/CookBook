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

    var onBlocked: (() -> Void)?

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

    func checkRecipeChallenger(reciepeId: String) {

        DataManager.shared.checkRecipeChallenger(documentId: reciepeId) { [weak self] result in

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

    func increaseLikes(documentId: String) {

        DataManager.shared.increaseLikes(documentId: documentId) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): Likes increase 1")
                
            case .failure(let error):

                print(error)
            }
        }
    }

    func decreaseLikes(documentId: String) {

        DataManager.shared.decreaseLikes(documentId: documentId) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): Likes decrease 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    func increaseFavoritesCounts(uid: String) {

        DataManager.shared.increaseFavoritesCounts(documentId: uid) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FavoritesCounts increased 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    func decreaseFavoritesCounts(uid: String) {

        DataManager.shared.decreaseFavoritesCounts(documentId: uid) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FavoritesCounts decreased 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    func addFavoritesUserId(documentId: String, favoritesUserId: String) {

        DataManager.shared.addfavoritesUserId(
            documentId: documentId,
            favoritesUserId: favoritesUserId
        ) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId) recipe: \(favoritesUserId) added")

            case .failure(let error):

                print(error)
            }
        }
    }

    func removeFavoritesUserId(documentId: String, favoritesUserId: String) {

        DataManager.shared.removefavoritesUserId(
            documentId: documentId,
            favoritesUserId: favoritesUserId
        ) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId) recipe: \(favoritesUserId) removed")

            case .failure(let error):

                print(error)
            }

        }
    }

    func updateBlockList(uid: String, recipeId: String) {

        DataManager.shared.updateBlockList(
            uid: uid,
            recipeId: recipeId
        ) { [weak self] result in

            switch result {

            case .success(_):

                print("BlockList update success")

                // goHomeVC after blocked
                self?.onBlocked?()

            case.failure(let error):

                print(error)
            }
        }
    }

    func updateFeedStatus(feedId documentId: String, uid: String) {

        DataManager.shared.updateFeedChallengeStatus(
            documentId: documentId,
            uid: uid
        ) { [weak self] result in

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
