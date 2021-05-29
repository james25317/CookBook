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

            // fetch Recipe (snapshotListener 實時更新)
            fetchRecipe(with: recipeId)
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    @IBAction func goReadModePage(_ sender: Any) {

        guard let readModeVC = storyboard?
            .instantiateViewController(withIdentifier: "ReadMode") as? ReadModeViewController else { return }

        // pass data to ReadModePage
        readModeVC.viewModel = viewModel

        self.present(readModeVC, animated: true, completion: nil)
    }

    private func fetchRecipe(with recipeId: String) {

        // 拿 Recipe
        viewModel.fetchRecipe(reciepeId: recipeId) { [weak self] result in

            switch result {

            case .failure(let error):

                print("Error: \(error)")

            case .success(let recipe):

                // 監聽值變動，回傳並賦值 recipe
                self?.viewModel.recipe = recipe

                // 監聽值變動，更新資料
                self?.setupRecipePreview(with: recipe)
            }
        }
    }

    private func setupRecipePreview(with recipe: Recipe) {

        imageViewRecipeMainImage.loadImage(recipe.mainImage)

        labelRecipeName.text = recipe.name

        labelRecipeDescription.text = recipe.description

        labelLikesCounts.text = String(describing: recipe.likes)

        labelIngredientsCounts.text = String(describing: recipe.ingredients.count)

        labelStepsCounts.text = String(describing: recipe.steps.count)
    }
}
