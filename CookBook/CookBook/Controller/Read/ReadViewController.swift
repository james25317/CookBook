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

    var recipe: Recipe?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupRecipePreview()
    }

    @IBAction func goReadMode(_ sender: Any) {

        guard let readModeVC = storyboard?
            .instantiateViewController(withIdentifier: "ReadMode") as? ReadModeViewController else { return }

        present(readModeVC, animated: true, completion: nil)
    }

    private func setupRecipePreview() {

        guard let recipe = recipe else { return }

        imageViewRecipeMainImage.loadImage(recipe.mainImage)

        labelRecipeName.text = recipe.name

        labelRecipeDescription.text = recipe.description

        labelLikesCounts.text = String(describing: recipe.likes)

        labelIngredientsCounts.text = String(describing: recipe.ingredients.count)

        labelStepsCounts.text = String(describing: recipe.steps.count)
    }
}
