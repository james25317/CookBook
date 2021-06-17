//
//  FeedTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/13.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPortrait: UIImageView!

    @IBOutlet weak var labelUserName: UILabel!

    @IBOutlet weak var labelCreatedTime: UILabel!

    @IBOutlet weak var imageViewRecipe: UIImageView!

    @IBOutlet weak var labelRecipeName: UILabel!

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

        labelRecipeName.text = viewModel.recipeName

        if viewModel.portrait.isEmpty {

            imageViewPortrait.image = UIImage(named: "CookBook_image_placholder_portrait_dim")
        } else {

            imageViewPortrait.loadImage(viewModel.portrait)
        }

        if viewModel.mainImage.isEmpty {

            imageViewRecipe.image = UIImage(named: "CookBook_image_placholder_food_dim")
        } else {

            imageViewRecipe.loadImage(viewModel.mainImage)
        }
    }
}
