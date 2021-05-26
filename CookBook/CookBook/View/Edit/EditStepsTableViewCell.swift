//
//  StepsTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/15.
//

import UIKit

class EditStepsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewRecipeImage: UIImageView!

    @IBOutlet weak var labelStepTitle: UILabel!

    @IBOutlet weak var labelStepDescription: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.selectionStyle = .none
    }

    func layoutCell(with step: Step, at index: Int) {

        imageViewRecipeImage.loadImage(step.image)

        labelStepTitle.text = "Step \(index + 1)"

        labelStepDescription.text = step.description
    }
}
