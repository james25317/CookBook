//
//  ProfileViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation

class ProfileViewModel {

    public enum SortType: Int {

        case recipes = 0

        case favorites = 1

        case challenges = 2
    }

    let userViewModel: Box<UserViewModel?> = Box(nil)
    
    let recipeViewModels: Box<[RecipeViewModel]> = Box([])

    // let uid = UserDefaults.standard.string(forKey: UserDefaults.Keys.uid.rawValue)

    func fetchUserData(uid: String) {

        UserManager.shared.fetchUser(uid: uid) { [weak self] result in

            switch result {

            case .success(let user):

                print("Fetch user success: \(user)")

                self?.setUser(user)

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    // 根據 button.tag 切換資料內容（利用 filter 出資料）
    func switchSection(with uid: String, sortType: SortType) -> [RecipeViewModel] {

        switch sortType {

        case .recipes:

            return recipeViewModels.value.filter { recipeViewModel in

                recipeViewModel.recipe.ownerId == uid
            }

        case .favorites:

            return recipeViewModels.value.filter { recipeViewModel in

                recipeViewModel.recipe.favoritesUserId.contains(uid)
            }

        case .challenges:

            return recipeViewModels.value.filter { recipeViewModel in

                recipeViewModel.recipe.challenger == uid
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

    func fetchChallengesRecipesData(with ownerId: String) {

        DataManager.shared.fetchChallengesRecipes(ownerId: ownerId) { [weak self] result in

            switch result {

            case .success(let recipes):

                print("Fetch \(ownerId) challenges recipes success!")

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
