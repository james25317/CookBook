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

    // var recipe: Recipe?

    func fetchRecipe(reciepeId: String, completion: @escaping (Result<Recipe, Error>) -> Void = { _ in }) {

        DataManager.shared.fetchRecipe(documentId: reciepeId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success!")

                self?.recipeViewModel.value = RecipeViewModel(model: recipe)

                completion(.success(recipe))

            case .failure(let error):

                print("fetchData.failure: \(error)")

                completion(.failure(error))
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

    func updatefavoritesUserId(with documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        DataManager.shared.updatefavoritesUserId(documentId: documentId, favoritesUserId: favoritesUserId) { [weak self] result in

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
}
