//
//  ProfileViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation

class ProfileViewModel {

    let recipeViewModels = Box([RecipeViewModel]())

    func fetchRecipesData() {

        DataManager.shared.fetchRecipes { [weak self] result in

            switch result {

            case .success(let recipes):

                print("Fetch recipes success!")

                self?.setRecipes(recipes)

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    func convertRecipesToViewModels(from recipes: [Recipe]) -> [RecipeViewModel] {

        var viewModels: [RecipeViewModel] = []

        for recipe in recipes {

            let viewModel = RecipeViewModel(model: recipe)

            viewModels.append(viewModel)
        }

        return viewModels
    }

    func setRecipes(_ articles: [Recipe]) {

        recipeViewModels.value = convertRecipesToViewModels(from: articles)
    }
}
