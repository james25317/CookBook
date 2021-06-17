//
//  TodayViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/30.
//

import Foundation

class TodayViewModel {

    let todayRecipeViewModel: Box<TodayRecipeViewModel?> = Box(nil)

    var officialRecipe: Recipe?

    var onLoadImage: (() -> Void)?
    
    func fetchUser(uid: String) {

        UserManager.shared.fetchUserData(uid: uid) { result in

            switch result {

            case .success(let user):

                print("Fetch user success: \(user)")

                // fetch latest user data
                UserManager.shared.user = user

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    func fetchTodayRecipe() {

        RecipeManager.shared.fetchTodayRecipeData { [weak self] result in

            switch result {

            case .success(let todayRecipe):

                self?.setTodayRecipeToViewModel(with: todayRecipe)

            case .failure(let error):

                print("fetchData failure: \(error)")
            }
        }
    }

    func fetchOfficialRecipe() {

        RecipeManager.shared.fetchOfficialRecipeData { [weak self] result in

            switch result {

            case .success(let officialRecipe):

                self?.officialRecipe = officialRecipe

                self?.onLoadImage?()
                
            case .failure(let error):

                print("fetchData failure: \(error)")
            }
        }
    }

    func setTodayRecipeToViewModel(with todayRecipe: TodayRecipe) {

        todayRecipeViewModel.value = convertTodayRecipeToViewModel(from: todayRecipe)
    }

    func convertTodayRecipeToViewModel(from todayRecipe: TodayRecipe) -> TodayRecipeViewModel {

        let viewModel = TodayRecipeViewModel(model: todayRecipe)

        return viewModel
    }
}
