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

        guard let data = viewModel else { return }

        imageViewRecipe.loadImage(data.mainImage)

        labelLikesCounts.text = String(describing: data.likes)
    }
}
