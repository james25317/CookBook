//
//  ProfileCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/14.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewRecipe: UIImageView!

    @IBOutlet weak var imageViewIcon: UIImageView!
    
    @IBOutlet weak var labelLikesCounts: UILabel!

    @IBOutlet weak var viewRecipeView: UIView!
    
    @IBOutlet weak var viewDraftView: UIView!

    @IBOutlet weak var labelDraftRecipeName: UILabel!
    
    var viewModel: RecipeViewModel?

    func setup(viewModel: RecipeViewModel) {

        self.viewModel = viewModel

        layoutCell()
    }

    func layoutCell() {

        guard let viewModel = viewModel else { return }

        if viewModel.mainImage.isEmpty {

            imageViewRecipe.image = UIImage(named: "CookBook_image_placholder_food_dim")
        } else {

            imageViewRecipe.loadImage(viewModel.mainImage)
        }

        labelLikesCounts.text = String(describing: viewModel.likes)

        labelDraftRecipeName.text = String(describing: viewModel.name)
    }
}
