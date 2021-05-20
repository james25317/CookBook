//
//  ProfileCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/14.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewRecipe: UIImageView!

    @IBOutlet weak var labelLikesCounts: UILabel!

    var viewModel: RecipeViewModel?

    func setup(viewModel: RecipeViewModel) {

        self.viewModel = viewModel

        layoutCell()
    }

    func layoutCell() {

        imageViewRecipe.loadImage(viewModel?.mainImage)

        labelLikesCounts.text = String(describing: viewModel?.likes)
    }
}
