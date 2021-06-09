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

    @IBOutlet weak var textViewRecipeDescription: UITextView!

    @IBOutlet weak var labelLikesCounts: UILabel!

    @IBOutlet weak var labelIngredientsCounts: UILabel!

    @IBOutlet weak var labelStepsCounts: UILabel!

    let viewModel = ReadViewModel()

    var recipeId: String?

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.recipeViewModel.bind { [weak self] recipeViewModel in

            guard let recipeViewModel = recipeViewModel else { return }

            self?.imageViewRecipeMainImage.loadImage(recipeViewModel.recipe.mainImage)

            self?.labelRecipeName.text = recipeViewModel.recipe.name
            
            self?.textViewRecipeDescription.text = recipeViewModel.recipe.description

            self?.labelLikesCounts.text = String(describing: recipeViewModel.recipe.likes)

            self?.labelIngredientsCounts.text = String(describing: recipeViewModel.recipe.ingredients.count)

            self?.labelStepsCounts.text = String(describing: recipeViewModel.recipe.steps.count)
        }

        guard let recipeId = recipeId else { return }

        viewModel.fetchRecipe(reciepeId: recipeId)
    }

    @IBAction func goReadModePage(_ sender: Any) {

        guard let readModeVC = storyboard?
            .instantiateViewController(withIdentifier: "ReadMode") as? ReadModeViewController else { return }

        // pass data to ReadModePage
        readModeVC.viewModel = viewModel

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.pushViewController(readModeVC, animated: true)
    }
}
