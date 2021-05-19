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

        // Initialization code
    }

    // 綁定VM對象來做替換
    func setup(viewModel: FeedViewModel) {

        self.viewModel = viewModel

        layoutCell()

        roundedImageView()
    }

    private func layoutCell() {

        labelUserName.text = viewModel?.name

        labelCreatedTime.text = viewModel?.createdTime

        labelRecipeName.text = viewModel?.recipeName

        imageViewPortrait.loadImage(viewModel?.portrait)

        imageViewRecipe.loadImage(viewModel?.mainImage)
    }

    private func roundedImageView() {

        imageViewPortrait.layer.cornerRadius = imageViewPortrait.frame.height / 2
    }
}
