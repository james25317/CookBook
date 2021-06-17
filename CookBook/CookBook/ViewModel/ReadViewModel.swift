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
    
    func fetchRecipe(reciepeId: String) {

        RecipeManager.shared.fetchRecipeData(documentId: reciepeId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success")

                self?.recipeViewModel.value = RecipeViewModel(model: recipe)

            case .failure(let error):

                print("Fetch failure: \(error)")
            }
        }
    }

    func checkRecipeChallenger(reciepeId: String) {

        RecipeManager.shared.checkRecipeChallenger(documentId: reciepeId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Check recipe success")

                if !recipe.challenger.isEmpty {

                    print("Challenger is not empty")

                    self?.onDenied?()

                    self?.onReturned?()
                } else {

                    print("Challenger is empty")

                    self?.onGranteed?()
                }

            case .failure(let error):

                print("Fetch failure: \(error)")
            }
        }
    }

    func updateLikes(documentId: String, by number: Int) {

        RecipeManager.shared.updateLikes(documentId: documentId, number: number) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): \(number) likes updated")
                
            case .failure(let error):

                print(error)
            }
        }
    }
    
    func increaseFavoritesCounts(uid: String) {

        UserManager.shared.increaseFavoritesCounts(documentId: uid) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FavoritesCounts increased 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    func decreaseFavoritesCounts(uid: String) {

        UserManager.shared.decreaseFavoritesCounts(documentId: uid) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FavoritesCounts decreased 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    func addFavoritesUserId(documentId: String, favoritesUserId: String) {

        RecipeManager.shared.addfavoritesUserId(
            documentId: documentId,
            favoritesUserId: favoritesUserId
        ) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId) recipe: \(favoritesUserId) added")

            case .failure(let error):

                print(error)
            }
        }
    }

    func removeFavoritesUserId(documentId: String, favoritesUserId: String) {

        RecipeManager.shared.removefavoritesUserId(
            documentId: documentId,
            favoritesUserId: favoritesUserId
        ) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId) recipe: \(favoritesUserId) removed")

            case .failure(let error):

                print(error)
            }
        }
    }

    func updateBlockList(uid: String, recipeId: String) {

        UserManager.shared.updateBlockList(
            uid: uid,
            recipeId: recipeId
        ) { [weak self] result in

            switch result {

            case .success(_):

                print("BlockList update success")

                self?.onBlocked?()

            case.failure(let error):

                print(error)
            }
        }
    }

    func updateFeedStatus(feedId documentId: String, uid: String) {

        FeedManager.shared.updateFeedChallengeStatus(
            documentId: documentId,
            uid: uid
        ) { result in

            switch result {

            case .success(let documentId):

                print("Feed \(documentId): challenge status \(uid) updated")

            case .failure(let error):

                print(error)
            }
        }
    }

    func updateRecipeStatus(recipeId documentId: String, uid: String) {

        RecipeManager.shared.updateRecipeChallengeStatus(
            documentId: documentId,
            uid: uid) { result in

            switch result {

            case .success(let documentId):

                print("Recipe \(documentId): challenger \(uid) updated")

            case .failure(let error):

                print(error)
            }
        }
    }
}
