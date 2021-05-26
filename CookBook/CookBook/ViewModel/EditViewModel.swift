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

    // init Recipe
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

    // init Ingredient
    var ingredient = Ingredient(
        amount: 0,
        name: "",
        unit: ""
    )

    // init Step
    var step = Step(
        description: "",
        image: ""
    )

    func onNameChanged(text name: String) {

        self.recipe.name = name
    }

    func onIngredientsDescriptionChanged(text description: String) {

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

    func onStepsDescriptionChanged(text description: String) {

        self.step.description = description
    }

    // 來自 EditIngredientsVM
    func updateIngredients(with ingredients: [Ingredient]) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        DataManager.shared.updateIngredients(documentId: documentId, ingredients: ingredients) { result in

            switch result {

            case .success:

                print("Ingredient updated, success")

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
