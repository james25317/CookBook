//
//  TodayViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/30.
//

import Foundation

class TodayViewModel {

    let todayRecipeViewModel: Box<TodayRecipeViewModel?> = Box(nil)

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

    func setTodayRecipe(_ todayRecipe: TodayRecipe) {

        todayRecipeViewModel.value = convertTodayRecipeToViewModel(from: todayRecipe)
    }

    func convertTodayRecipeToViewModel(from todayRecipe: TodayRecipe) -> TodayRecipeViewModel {

        let viewModel = TodayRecipeViewModel(model: todayRecipe)

        return viewModel
    }
}
