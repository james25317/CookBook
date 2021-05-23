//
//  ProfileViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation

class ProfileViewModel {

    let userViewModel: Box<UserViewModel?> = Box(nil)
    
    let recipeViewModels: Box<[RecipeViewModel]> = Box([])

    func fetchUserData() {

        DataManager.shared.fetchUser { [weak self] result in

            switch result {

            case .success(let user):

                print("Fetch user success!")

                self?.setUser(user)

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

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

    func convertUserToViewModel(from user: User) -> UserViewModel {

        let viewModel = UserViewModel(model: user)

        return viewModel
    }

    func convertRecipesToViewModels(from recipes: [Recipe]) -> [RecipeViewModel] {

        var viewModels: [RecipeViewModel] = []

        for recipe in recipes {

            let viewModel = RecipeViewModel(model: recipe)

            viewModels.append(viewModel)
        }

        return viewModels
    }

    func setUser(_ user: User) {

        userViewModel.value = convertUserToViewModel(from: user)
    }

    func setRecipes(_ articles: [Recipe]) {

        recipeViewModels.value = convertRecipesToViewModels(from: articles)
    }
}
