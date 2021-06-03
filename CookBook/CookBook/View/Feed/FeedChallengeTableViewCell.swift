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

        roundedImageView()
    }

    private func layoutCell() {

        labelUserName.text = viewModel?.name

        labelCreatedTime.text = viewModel?.createdTime

        imageViewPortrait.loadImage(viewModel?.portrait)

        imageViewOwnerRecipe.loadImage(viewModel?.mainImage)

        labelOwnerRecipeName.text = viewModel?.name
    }

    private func roundedImageView() {

        imageViewPortrait.layer.cornerRadius = imageViewPortrait.frame.size.height / 2
    }
}
