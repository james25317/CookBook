//
//  EditStepsCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/25.
//

import UIKit

class EditStepsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelStepTitle: UILabel!

    @IBOutlet weak var imageViewUploadedImage: UIImageView!

    @IBOutlet weak var textViewDescription: UITextView! {

        didSet {

            textViewDescription.delegate = self
        }
    }

    @IBOutlet weak var buttondelete: UIButton!

    @IBAction func deleteImage(_ sender: Any) {
        
    }

    var viewModel: EditViewModel?

    var onDescriptionChanged: ((String) -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()
    }

    func setupCell(with step: Step, at index: Int) {

        labelStepTitle.text = "Step \(index + 1)"

        imageViewUploadedImage.loadImage(step.image)

        textViewDescription.text = step.description
    }
}

extension EditStepsCollectionViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        guard let description = textView.text else { return }

        // 傳回去 EditSteps VC 本地 Steps 資料
        onDescriptionChanged?(description)
    }
}
