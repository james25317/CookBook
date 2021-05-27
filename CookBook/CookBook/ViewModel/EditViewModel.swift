//
//  EditViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/22.
//

import Foundation
import Firebase
import FirebaseStorage

class EditViewModel {

    let recipeViewModel: Box<RecipeViewModel?> = Box(nil)

    // init Recipe
    var recipe = Recipe(
        id: "",
        createdTime: Timestamp(date: Date()),
        description: "",
        favoritesUserId: [],

        ingredients: [
            Ingredient(
            amount: 1,
            name: "名稱",
            unit: "單位"
            )
        ],

        isEditDone: false,
        likedUserId: [],
        likes: 0,
        mainImage: "",
        name: "",
        owner: "",

        steps: [
            Step(
            description: "請輸入步驟的描述",
            image: "https://loremflickr.com/320/240/food"
            )
        ]
    )

    // init Ingredient
    var ingredient = Ingredient(
        amount: 1,
        name: "名稱",
        unit: "單位"
    )

    // init Step
    var step = Step(
        description: "請輸入步驟的描述",
        image: "https://loremflickr.com/320/240/food"
    )

    func onNameChanged(text name: String) {

        self.recipe.name = name
    }

    func onIngredientsDescriptionChanged(text description: String) {

        self.recipe.description = description
    }

    func onIngredientNameChanged(text name: String) {

        self.ingredient.name = name
    }

    func onAmountChanged(text amount: Int) {

        self.ingredient.amount = amount
    }

    func onUnitChanged(text unit: String) {

        self.ingredient.unit = unit
    }

    func onStepsDescriptionChanged(text description: String) {

        self.step.description = description
    }

    func uploadImagePickerImage(with pickerImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {

        let uuid = UUID().uuidString

        // 選擇的圖片（並壓縮）
        guard let image = pickerImage.jpegData(compressionQuality: 0.5) else { return }

        let storageRef = Storage.storage().reference()

        let imageRef = storageRef.child("CookBookImages").child("\(uuid).jpg")

        // 上傳圖片
        imageRef.putData(image, metadata: nil) { metadata, error in

            if let error = error {

                completion(.failure(error))
            }

            guard let metadata = metadata else { return }

            imageRef.downloadURL { url, error in

                if let error = error {

                    completion(.failure(error))
                }

                if let url = url {

                    // escaping callback
                    completion(.success(url.absoluteString))
                }
            }
        }
    }


    func updateIngredients(with ingredients: [Ingredient]) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        DataManager.shared.updateIngredients(documentId: documentId, ingredients: ingredients) { result in

            switch result {

            case .success:

                print("Ingredients updated, success")

            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }

    func updateSteps(with steps: [Step]) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        DataManager.shared.updateSteps(documentId: documentId, steps: steps) { result in

            switch result {

            case .success:

                print("Steps updated, success")

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
