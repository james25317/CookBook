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

    var recipeViewModel: Box<RecipeViewModel?> = Box(nil)

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
        ownerId: "",

        steps: [
            Step(
            description: "請輸入步驟的描述",
            image: "https://loremflickr.com/320/240/food"
            )
        ],

        challenger: ""
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

    // init Feed
    var feed = Feed(
        id: "",
        challenger: "",
        createdTime: Date().millisecondsSince1970,
        isChallenged: false,
        mainImage: "",
        name: "",
        ownerId: "",
        portrait: "",
        recipeId: "",
        recipeName: ""
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

    func updateMainImage(with mainImage: String, completion: @escaping (Result<String, Error>) -> Void) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        DataManager.shared.updateMainImage(documentId: documentId, mainImage: mainImage) { result in

            switch result {

            case .success(let mainImage):

                print("MainImage updated, success")

                completion(.success(mainImage))

            case .failure(let error):

                print("Updated fail, failure: \(error)")

                completion(.failure(error))
            }
        }
    }

    func updateRecipesCounts(with uid: String) {

        DataManager.shared.updateRecipesCounts(uid: uid) { result in

            switch result {

            case .success(let userDocumentId):

                print("\(userDocumentId): RecipesCounts increase 1")

            case .failure(let error):

                print(error)
            }

        }
    }

    func updateChallengesCounts(with uid: String) {

        DataManager.shared.updateChallengesCounts(uid: uid) { result in

            switch result {

            case .success(let userDocumentId):

                print("\(userDocumentId): ChallengesCounts increase 1")

            case .failure(let error):

                print(error)
            }

        }
    }

    func createRecipeData(with recipe: inout Recipe, with uid: String) {

        DataManager.shared.createRecipe(recipe: &recipe, uid: uid) { result in

            switch result {

            case .success(let documentId):

                print("ID: \(documentId) CookBook Created")

                // 用回傳的 documentId 再去發一次請求，同步這個最新創的食譜
                self.fetchRecipe(documentId: documentId)

            case .failure(let error):

                print("Create fail, failure: \(error)")
            }
        }

        print("Initial recipe: \(recipe)")
    }

    func createFeedData(with feed: inout Feed) {

        DataManager.shared.createFeed(feed: &feed) { result in

            switch result {

            case .success(let documentId):

                print("ID: \(documentId) Feed Created")

            case .failure(let error):

                print("Create fail, failure: \(error)")
            }
        }

        print("Initial recipe: \(feed)")
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

        // 接回有了 documentId 的 recipe 至 revipeViewModel.value (this is why.)
        recipeViewModel.value = convertRecipeToViewModel(from: recipe)
    }

    func convertRecipeToViewModel(from recipe: Recipe) -> RecipeViewModel {

        let viewModel = RecipeViewModel(model: recipe)

        return viewModel
    }

    func convertRecipeToFeed(from recipe: Recipe, challengeOn: Bool) -> Feed {

        let feed = Feed(
            id: "FeedDocumentId",
            challenger: "",
            createdTime: Date().millisecondsSince1970,
            isChallenged: !challengeOn,
            mainImage: recipe.mainImage,
            name: UserManager.shared.user.name,
            ownerId: recipe.ownerId,
            portrait: UserManager.shared.user.portrait,
            recipeId: recipe.id!,
            recipeName: recipe.name
        )

        return feed
    }
}
