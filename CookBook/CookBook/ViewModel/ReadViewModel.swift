//
//  ReadViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/27.
//

import Foundation
import Firebase

class ReadViewModel {

    // init Recipe
    var recipe = Recipe(
        id: "recipeDocumentId",
        createdTime: Timestamp.init(),
        description: "",
        favoritesUserId: [],
        ingredients: [],
        isEditDone: Bool.init(),
        likedUserId: [],
        likes: 0,
        mainImage: "",
        name: "",
        ownerId: "",
        steps: []
    )

    // var recipe: Recipe?

    // fetch Recipe with "recipeDocumentId"
//    func fetchRecipe(reciepeId: String) {
//
//        DataManager.shared.fetchRecipe(documentId: reciepeId) { [weak self] result in
//
//            switch result {
//
//            case .success(let recipe):
//
//                print("Fetch recipe success!")
//
//                self?.setRecipe(with: recipe)
//
//            case .failure(let error):
//
//                print("fetchData.failure: \(error)")
//            }
//        }
//    }
//
//    func setRecipe(with recipe: Recipe) {
//
//        self.recipe = recipe
//    }
}
