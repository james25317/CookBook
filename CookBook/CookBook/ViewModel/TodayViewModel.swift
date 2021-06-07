//
//  TodayViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/30.
//

import Foundation

class TodayViewModel {

    let todayRecipeViewModel: Box<TodayRecipeViewModel?> = Box(nil)

    var recipe: Recipe?

    var onReNewed: (() -> Void)?
    
    func fetchUserData(uid: String) {

        UserManager.shared.fetchUser(uid: uid) { [weak self] result in

            switch result {

            case .success(let user):

                print("Fetch user success: \(user)")

                // fetch 最新資料至 UserManager
                UserManager.shared.user = user

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    // fetch collection("Today").document("TodayRecipe")
    func fetchTodayRecipeData() {

        DataManager.shared.fetchTodayRecipe { [weak self] result in

            switch result {

            case .success(let todayRecipe):

                self?.setTodayRecipe(todayRecipe)

            case .failure(let error):

                print("fetchData failure: \(error)")
            }
        }
    }

    // query collection("Recipe").whereField("ownerId", isEqualTo: "official")
    func fetchOfficialRecipeData() {

        DataManager.shared.fetchOfficialRecipe { [weak self] result in

            switch result {

            case .success(let officialRecipe):

                // assign official recipe data
                self?.recipe = officialRecipe

                self?.onReNewed?()
                
            case .failure(let error):

                print("fetchData failure: \(error)")
            }
        }
    }

    func setTodayRecipe(_ todayRecipe: TodayRecipe) {

        todayRecipeViewModel.value = convertTodayRecipeToViewModel(from: todayRecipe)
    }

    func convertTodayRecipeToViewModel(from todayRecipe: TodayRecipe) -> TodayRecipeViewModel {

        let viewModel = TodayRecipeViewModel(model: todayRecipe)

        return viewModel
    }
}
