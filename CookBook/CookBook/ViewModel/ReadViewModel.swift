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

    var onDenied: (() -> Void)?

    var onReturned: (() -> Void)?

    var onGranteed: (() -> Void)?
    
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

        DataManager.shared.fetchRecipe(documentId: reciepeId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success!")

                if !recipe.challenger.isEmpty {

                    // challenger 已經有值:
                    // 顯示提示＆返回主頁

                    // 提示彈窗
                    self?.onDenied?()

                    // 返回主頁
                    self?.onReturned?()
                } else {

                    // challenger 無值:
                    // 1. 上傳當前 uid 為 challenger
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

    func updateFavoritesCounts(with uid: String) {

        DataManager.shared.updateFavoritesCounts(uid: uid) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FavoritesCounts increase 1")

            case .failure(let error):

                print(error)
            }

        }
    }

    func updateFavoritesUserId(to documentId: String, with favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

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

    func updateChallenger(feedId documentId: String, uid: String) {

        DataManager.shared.updateChallengeStatus(
            documentId: documentId,
            uid: uid) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): challenger \(uid) added")

            case .failure(let error):

                print(error)
            }
        }
    }
}
