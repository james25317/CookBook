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
            name: "Ingredient",
            unit: "Unit"
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
            description: "Enter Steps Description",
            image: ""
            )
        ],

        challenger: ""
    )

    // init Ingredient
    var ingredient = Ingredient(
        amount: 1,
        name: "Ingredient",
        unit: "Unit"
    )

    // init Step
    var step = Step(
        description: "Enter Steps Description",
        image: ""
    )

    var feedId: String?

    var challenger: String?

    var challengerRecipeId: String?

    var challengerRecipeName: String?

    var challengerRecipeMainImage: String?

    var onCreatedDone: (() -> Void)?

    var onChallengeCreatedDone: (() -> Void)?

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

    // MARK: - uploadImagePickerImage
    func uploadImagePickerImage(with pickerImage: UIImage, completion: @escaping (Result<String, Error>) -> Void) {

        let uuid = UUID().uuidString

        guard let image = pickerImage.jpegData(compressionQuality: 0.5) else { return }

        let storageRef = Storage.storage().reference()

        let imageRef = storageRef.child("CookBookImages").child("\(uuid).jpg")

        imageRef.putData(image, metadata: nil) { metadata, error in

            if let error = error {

                completion(.failure(error))
            }

            guard metadata != nil else { return }

            imageRef.downloadURL { url, error in

                if let error = error {

                    completion(.failure(error))
                }

                if let url = url {

                    completion(.success(url.absoluteString))
                }
            }
        }
    }

    // MARK: - uploadIngredients
    func uploadIngredients(with ingredients: [Ingredient]) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        RecipeManager.shared.uploadIngredientsData(documentId: documentId, ingredients: ingredients) { result in

            switch result {

            case .success:

                print("Ingredients updated, success")

            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }

    // MARK: - uploadSteps
    func uploadSteps(with steps: [Step]) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        RecipeManager.shared.uploadStepsData(documentId: documentId, steps: steps) { result in

            switch result {

            case .success:

                print("Steps updated, success")
                
            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }

    // MARK: - updateRecipeEditStatus
    func updateRecipeEditStatus() {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        RecipeManager.shared.updateIsEditDone(documentId: documentId) { result in

            switch result {

            case .success(_):

                print("IsEditDone updated, success")

            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }

    // MARK: - uploadMainImage
    func uploadMainImage(with mainImage: String) {

        guard let documentId = recipeViewModel.value?.recipe.id else { return }

        RecipeManager.shared.uploadMainImage(documentId: documentId, mainImage: mainImage) { [weak self] result in

            switch result {

            case .success(let mainImage):

                guard let value = self?.recipeViewModel.value else { return }

                // check if challenger is assigned or not
                if !value.recipe.challenger.isEmpty {

                    self?.onChallengeCreatedDone?()
                } else {

                    self?.onCreatedDone?()
                }

                print("MainImage: \(mainImage) updated")

            case .failure(let error):

                print("Updated fail, failure: \(error)")
            }
        }
    }

    // MARK: - increaseRecipesCounts
    func increaseRecipesCounts(with uid: String) {

        UserManager.shared.increaseRecipesCounts(uid: uid) { result in

            switch result {

            case .success(let userDocumentId):

                print("\(userDocumentId): RecipesCounts increase 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    // MARK: - updateChallengesCounts
    func updateChallengesCounts(with uid: String) {

        UserManager.shared.updateChallengesCounts(uid: uid) { result in

            switch result {

            case .success(let userDocumentId):

                print("\(userDocumentId): ChallengesCounts increase 1")

            case .failure(let error):

                print(error)
            }
        }
    }

    // MARK: - updateFeedChallengeStatus
    func updateFeedChallengeStatus(documentId: String, recipeId: String, mainImage: String, recipeName: String) {

        FeedManager.shared.updateChallengeStatus(
            documentId: documentId,
            recipeId: recipeId,
            mainImage: mainImage,
            recipeName: recipeName
        ) { result in

            switch result {

            case .success(let documentId):

                print("\(documentId): FeedChallengeDoneStatus updated")

            case .failure(let error):

                print(error)
            }
        }
    }

    // MARK: - createRecipe
    func createRecipe(with recipe: inout Recipe, with uid: String) {

        RecipeManager.shared.createRecipeData(recipe: &recipe, uid: uid) { result in

            switch result {

            case .success(let documentId):

                print("ID: \(documentId) CookBook Created")

                self.fetchRecipe(documentId: documentId)

            case .failure(let error):

                print("Create fail, failure: \(error)")
            }
        }

        print("Initial recipe: \(recipe)")
    }

    // MARK: - createFeed
    func createFeed(with feed: inout Feed) {

        FeedManager.shared.createFeedData(feed: &feed) { result in

            switch result {

            case .success(let documentId):

                print("ID: \(documentId) Feed Created")

            case .failure(let error):

                print("Create fail, failure: \(error)")
            }
        }

        print("Initial recipe: \(feed)")
    }

    // MARK: - fetchRecipe
    func fetchRecipe(documentId: String) {

        RecipeManager.shared.fetchRecipeData(documentId: documentId) { [weak self] result in

            switch result {

            case .success(let recipe):

                print("Fetch recipe success!")

                self?.setRecipeToViewModel(recipe: recipe)

            case .failure(let error):

                print("fetchData.failure: \(error)")
            }
        }
    }

    func setRecipeToViewModel(recipe: Recipe) {

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
            challengerRecipeId: "",
            challengerRecipeName: "",
            challengerRecipeMainImage: "",
            createdTime: Date().millisecondsSince1970,
            isChallenged: !challengeOn,
            mainImage: recipe.mainImage,
            name: UserManager.shared.user.name,
            ownerId: recipe.ownerId,
            portrait: UserManager.shared.user.portrait,
            recipeId: recipe.id ?? "",
            recipeName: recipe.name
        )
        
        return feed
    }
}
