//
//  ReadViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class ReadViewController: UIViewController {

    @IBOutlet weak var imageViewRecipeMainImage: UIImageView!

    @IBOutlet weak var labelRecipeName: UILabel!

    @IBOutlet weak var labelRecipeDescription: UILabel!

    @IBOutlet weak var labelLikesCounts: UILabel!

    @IBOutlet weak var labelIngredientsCounts: UILabel!

    @IBOutlet weak var labelStepsCounts: UILabel!

    let viewModel = ReadViewModel()

    var recipeId: String? {

        didSet {

            guard let recipeId = recipeId else { return }

            // fetch Recipe(with snapshotListener)
            fetchRecipe(with: recipeId)
        }
    }

    // var recipe: Recipe?

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    @IBAction func goReadModePage(_ sender: Any) {

        guard let readModeVC = storyboard?
            .instantiateViewController(withIdentifier: "ReadMode") as? ReadModeViewController else { return }

        // guard let recipe = viewModel.recipe else { return }

        // pass data to ReadModePage
        readModeVC.viewModel = viewModel

        self.present(readModeVC, animated: true, completion: nil)
    }

    private func fetchRecipe(with recipeId: String) {

        // 去拿 Recipe
        viewModel.fetchRecipe(reciepeId: recipeId) { [weak self] result in

            switch result {

            case .failure(let error):

                print("Error: \(error)")

            case .success(let recipe):

                // 拿回傳的資料傳過去
                // readVC.recipe = recipe

                self?.viewModel.recipe = recipe

                self?.setupRecipePreview(with: recipe)
            }
        }
    }

    private func setupRecipePreview(with recipe: Recipe) {

        // guard let recipe = viewModel.recipe else { return }

        imageViewRecipeMainImage.loadImage(recipe.mainImage)

        labelRecipeName.text = recipe.name

        labelRecipeDescription.text = recipe.description

        labelLikesCounts.text = String(describing: recipe.likes)

        labelIngredientsCounts.text = String(describing: recipe.ingredients.count)

        labelStepsCounts.text = String(describing: recipe.steps.count)
    }
}
