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

    // 複寫外框初始值設定達到內縮效果
    override var frame: CGRect {

        get {
            return super.frame
        }
        set {
            var frame = newValue

            frame.origin.x += 16

            frame.size.width -= 2 * 16

            frame.origin.y += 24

            // frame.size.height -= 2 * 16

            super.frame = frame
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        
        self.selectionStyle = .none

        roundedImageView()
    }

    // 綁定VM對象來做替換
    func setup(viewModel: FeedViewModel) {

        self.viewModel = viewModel

        layoutCell()
    }

    private func layoutCell() {

        labelUserName.text = viewModel?.name

        labelCreatedTime.text = viewModel?.createdTime

        labelRecipeName.text = viewModel?.recipeName

        imageViewPortrait.loadImage(viewModel?.portrait)

        imageViewRecipe.loadImage(viewModel?.mainImage)
    }

    private func roundedImageView() {

        imageViewPortrait.layer.cornerRadius = imageViewPortrait.frame.size.height / 2
    }
}
