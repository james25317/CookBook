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

    var documentId: String?

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

    // 來自 EditIngredientsVM
    var ingredient = Ingredient(
        amount: 0,
        name: "",
        unit: ""
    )

    func onNameChanged(text name: String) {

        self.recipe.name = name
    }

    func onDescriptionChanged(text description: String) {

        self.recipe.description = description
    }

    // 來自 EditIngredientsVM
    func onIngredientNameChanged(text name: String) {

        self.ingredient.name = name
    }

    // 來自 EditIngredientsVM
    func onAmountChanged(text amount: Int) {

        self.ingredient.amount = amount
    }

    // 來自 EditIngredientsVM
    func onUnitChanged(text unit: String) {

        self.ingredient.unit = unit
    }

    // 來自 EditIngredientsVM
    var onIngredientUpdated: (() -> Void)?

    // 來自 EditIngredientsVM
    func updateIngredients(with ingredients: [Ingredient]) {

        guard let documentId = recipeViewModel.value?.id else { return }

        DataManager.shared.updateIngredients(documentId: documentId, ingredients: ingredients) { result in

            switch result {

            case .success:

                print("Ingredient updated, success")

                self.onIngredientUpdated?()

            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }

    func createRecipe(with recipe: inout Recipe) {

        DataManager.shared.createRecipe(recipe: &recipe) { result in

            switch result {

            case .success(let documentId):

                print("ID: \(documentId) CookBook Created")

                // 用回傳的 documentId 再去發一次請求
                self.fetchRecipe(documentId: documentId)

                // 儲存回傳的 DocumentId
                // self.documentId = documentId

            case .failure(let error):

                print("Create fail, failure: \(error)")
            }
        }
    }

    func fetchRecipe(documentId: String) {

        DataManager.shared.fetchRecipe(documentId: documentId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success!")

                self?.setRecipe(recipe)

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    func setRecipe(_ recipe: Recipe) {

        recipeViewModel.value = convertRecipeToViewModel(from: recipe)
    }

    func convertRecipeToViewModel(from recipe: Recipe) -> RecipeViewModel {

        let viewModel = RecipeViewModel(model: recipe)

        return viewModel
    }
}
