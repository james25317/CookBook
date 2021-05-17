//
//  FeedTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/13.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePortrait: UIImageView!

    @IBOutlet weak var labelName: UILabel!

    @IBOutlet weak var labelCreatedTime: UILabel!

    @IBOutlet weak var imageRecipe: UIImageView!

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

    }

    private func layoutCell() {

        labelName.text = viewModel?.name
        labelCreatedTime.text = viewModel?.createdTime
        labelRecipeName.text = viewModel?.recipeName
        imagePortrait.loadImage(viewModel?.portrait)
        imageRecipe.loadImage(viewModel?.mainImage)

    }
}
