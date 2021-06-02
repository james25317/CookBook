//
//  FeedTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/13.
//

import UIKit

class FeedChallengesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPortrait: UIImageView!

    @IBOutlet weak var labelUserName: UILabel!

    @IBOutlet weak var labelCreatedTime: UILabel!

    @IBOutlet weak var imageViewOwnerRecipe: UIImageView!

    @IBOutlet weak var labelOwnerRecipeName: UILabel!

    @IBOutlet weak var imageViewChallengeRecipe: UIImageView!

    @IBOutlet weak var labelChallengeRecipeName: UILabel!

    var viewModel: FeedViewModel?

    override func awakeFromNib() {

        super.awakeFromNib()

        self.selectionStyle = .none
        
        roundedImageView()
    }

    func setup(viewModel: FeedViewModel) {

        self.viewModel = viewModel

        layoutCell()
    }

    private func layoutCell() {

        labelUserName.text = viewModel?.name

        labelCreatedTime.text = viewModel?.createdTime

        imageViewPortrait.loadImage(viewModel?.portrait)

        imageViewOwnerRecipe.loadImage(viewModel?.mainImage)

        labelOwnerRecipeName.text = viewModel?.name

        // 加載挑戰成功後（Feed 發布後上傳的 mainImage）
        imageViewChallengeRecipe.loadImage("")

        // 加載挑戰成功後（Feed 發布後上傳的 name）
        labelChallengeRecipeName.text = "Try it!"
    }

    private func roundedImageView() {

        imageViewPortrait.layer.cornerRadius = imageViewPortrait.frame.size.height / 2
    }
}
