//
//  EditIngredientsViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/21.
//

import Foundation

class EditIngredientsViewModel {

    var ingredient = Ingredient(
        amount: 0,
        name: "",
        unit: ""
    )

    // 這邊要怎麼將輸入的內容自動append到這個陣列裡？
    var ingredients: [Ingredient] = [
        Ingredient(
        amount: 999,
        name: "name override",
        unit: "unit override"
        ),
        Ingredient(
        amount: 999,
        name: "name override",
        unit: "unit override"
        )
    ]

    func onIngredientNameChanged(text name: String) {

        self.ingredient.name = name
    }

    func onAmountChanged(text amount: Int) {

        self.ingredient.amount = amount
    }

    func onUnitChanged(text unit: String) {

        self.ingredient.unit = unit
    }

    var onIngredientUpdated: (() -> Void)?

    func update(with ingredients: inout [Ingredient]) {

        DataManager.shared.updateIngredient(ingredients: &ingredients) { result in

            switch result {

            case .success:

                print("Ingredient updated, success")

                self.onIngredientUpdated?()

            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }
}
