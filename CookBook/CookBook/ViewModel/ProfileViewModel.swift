//
//  ProfileViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation

class ProfileViewModel {

    public enum SortType: Int, CaseIterable {

        case recipes = 0

        case favorites

        case challenges
    }

    let userViewModel: Box<UserViewModel?> = Box(nil)
    
    let recipeViewModels: Box<[RecipeViewModel]> = Box([])
    
    func fetchUserData(uid: String) {

        UserManager.shared.fetchUserData(uid: uid) { [weak self] result in

            switch result {

            case .success(let user):

                self?.setUserToViewModel(user)

                // fetch latest user data
                UserManager.shared.user = user

                print("Fetch user success: \(user)")

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    // Based on button.tag, switching section contents（by filter types）
    func switchSection(uid: String, sortType: SortType) -> [RecipeViewModel] {

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

    func fetchRecipes() {

        DataManager.shared.fetchRecipesData { [weak self] result in

            switch result {

            case .success(let recipes):

                print("Fetch recipes success!")

                self?.setRecipesToViewModel(recipes)

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

    func setUserToViewModel(_ user: User) {

        userViewModel.value = convertUserToViewModel(from: user)
    }

    func setRecipesToViewModel(_ recipes: [Recipe]) {

        recipeViewModels.value = convertRecipesToViewModels(from: recipes)
    }
}
