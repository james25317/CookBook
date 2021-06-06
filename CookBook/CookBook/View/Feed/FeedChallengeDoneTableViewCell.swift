//
//  FeedTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/13.
//

import UIKit

class FeedChallengeDoneTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPortrait: UIImageView!

    @IBOutlet weak var labelUserName: UILabel!

    @IBOutlet weak var labelCreatedTime: UILabel!

    @IBOutlet weak var imageViewOwnerRecipe: UIImageView!

    @IBOutlet weak var labelOwnerRecipeName: UILabel!

    @IBOutlet weak var imageViewChallengerRecipe: UIImageView!

    @IBOutlet weak var labelChallengerRecipeName: UILabel!

    var viewModel: FeedViewModel?

    var onOwnerTapped: (() -> Void)?

    var onChallengerTapped: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

        self.selectionStyle = .none
    }

    func setup(viewModel: FeedViewModel) {

        self.viewModel = viewModel

        layoutCell()

        // roundedImageView()

        setupTapGesture()
    }

    private func layoutCell() {

        labelUserName.text = viewModel?.name

        labelCreatedTime.text = viewModel?.createdTime

        imageViewPortrait.loadImage(viewModel?.portrait)

        imageViewOwnerRecipe.loadImage(viewModel?.mainImage)

        labelOwnerRecipeName.text = viewModel?.recipeName

        imageViewChallengerRecipe.loadImage(viewModel?.challengerRecipeMainImage)

        labelChallengerRecipeName.text = viewModel?.challengerRecipeName
    }

    private func roundedImageView() {

        imageViewPortrait.layer.cornerRadius = imageViewPortrait.frame.size.height / 2
    }

    private func setupTapGesture() {

        let ownerRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(goOwnerReadPage))

        imageViewOwnerRecipe.isUserInteractionEnabled = true

        imageViewOwnerRecipe.addGestureRecognizer(ownerRecipeGesture)
        
        let challengerRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(goChallengerReadPage))

        imageViewChallengerRecipe.isUserInteractionEnabled = true

        imageViewChallengerRecipe.addGestureRecognizer(challengerRecipeGesture)
    }

    @objc func goOwnerReadPage() {

        print("OwnerRecipe tapped")
        
        onOwnerTapped?()
    }

    @objc func goChallengerReadPage() {

        print("ChallengerRecipe tapped")

        onChallengerTapped?()
    }
}
