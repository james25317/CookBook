//
//  ReadCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/14.
//

import UIKit

class ReadStepsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewStepImage: UIImageView!

    @IBOutlet weak var labelStepCounts: UILabel!

    @IBOutlet weak var textViewStepDescription: UITextView!

    override func awakeFromNib() {

        super.awakeFromNib()
    }

    func setupCell(with step: Step, at index: Int, total: Int) {

        imageViewStepImage.loadImage(step.image)

        labelStepCounts.text = "\(index) / \(total)"

        textViewStepDescription.text = step.description
    }
}
