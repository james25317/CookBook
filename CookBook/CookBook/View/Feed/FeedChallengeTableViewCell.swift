//
//  FeedChallengeTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/6/3.
//

import UIKit

class FeedChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPortrait: UIImageView!

    @IBOutlet weak var labelUserName: UILabel!

    @IBOutlet weak var labelCreatedTime: UILabel!

    @IBOutlet weak var imageViewOwnerRecipe: UIImageView!

    @IBOutlet weak var labelOwnerRecipeName: UILabel!

    var viewModel: FeedViewModel?
    
    override func awakeFromNib() {

        super.awakeFromNib()

        self.selectionStyle = .none
    }

    func setup(viewModel: FeedViewModel) {

        self.viewModel = viewModel

        layoutCell()
    }

    private func layoutCell() {

        guard let viewModel = viewModel else { return }

        labelUserName.text = viewModel.name

        labelCreatedTime.text = viewModel.createdTime

        if viewModel.portrait.isEmpty {

            imageViewPortrait.image = UIImage(named: "CookBook_image_placholder_portrait_dim")
        } else {

            imageViewPortrait.loadImage(viewModel.portrait)
        }

        if viewModel.mainImage.isEmpty {

            imageViewOwnerRecipe.image = UIImage(named: "CookBook_image_placholder_food_dim")
        } else {

            imageViewOwnerRecipe.loadImage(viewModel.mainImage)
        }

        labelOwnerRecipeName.text = viewModel.recipeName
    }
}
