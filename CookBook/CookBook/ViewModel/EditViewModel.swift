//
//  EditViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/22.
//

import Foundation
import Firebase

class EditViewModel {

    let recipeViewModel: Box<RecipeViewModel?> = Box(nil)

    // init a Recipe data set
    var recipe = Recipe(
        id: "",
        createdTime: Timestamp(date: Date()),
        description: "",
        favoritesUserId: [],
        ingredients: [],
        isEditDone: false,
        likedUserId: [],
        likes: 0,
        mainImage: "",
        name: "",
        owner: "",
        steps: []
    )

    func onNameChanged(text name: String) {

        self.recipe.name = name
    }

    func onDescriptionChanged(text description: String) {

        self.recipe.description = description
    }

    var onCreated: (() -> Void)?

    func createRecipe(with recipe: inout Recipe) {

        DataManager.shared.createRecipe(recipe: &recipe) { result in

            switch result {

            case .success(let documentId):

            print("ID: \(documentId) CookBook Created")

            case .failure(let error):

            print("Create fail, failure: \(error)")
            }
        }
    }

    func fetchRecipeData() {

        DataManager.shared.fetchRecipe { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success!")

                self?.setRecipe(recipe)

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    func convertRecipeToViewModel(from recipe: Recipe) -> RecipeViewModel {

        let viewModel = RecipeViewModel(model: recipe)

        return viewModel
    }

    func setRecipe(_ recipe: Recipe) {

        recipeViewModel.value = convertRecipeToViewModel(from: recipe)
    }
}
