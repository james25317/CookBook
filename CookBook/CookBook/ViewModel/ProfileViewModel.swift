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

    func fetchOwnerRecipesData(with ownerId: String) {

        DataManager.shared.fetchOwnerRecipes(ownerId: ownerId) { [weak self] result in

            switch result {

            case .success(let recipes):

                print("Fetch \(ownerId) recipes success!")

                self?.setRecipes(recipes)

            case .failure(let error):

                print("Fetch fail: \(error)")
            }
        }
    }

    func fetchFavoritesRecipesData(with ownerId: String) {

        DataManager.shared.fetchFavoritesRecipes(ownerId: ownerId) { [weak self] result in

            switch result {

            case .success(let recipes):

                print("Fetch \(ownerId) favorites recipes success!")

                self?.setRecipes(recipes)

            case .failure(let error):

                print("Fetch fail: \(error)")
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

    func setRecipes(_ recipes: [Recipe]) {

        recipeViewModels.value = convertRecipesToViewModels(from: recipes)
    }
}
