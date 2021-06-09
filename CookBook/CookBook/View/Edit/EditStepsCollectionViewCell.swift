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

        onDeleteStep?()
    }
    
    var onDescriptionChanged: ((String) -> Void)?

    var onDeleteStep: (() -> Void)?

    var onUploadedImageTapped: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

        setupTapGesture()
    }

    func setupCell(with step: Step, at index: Int) {

        labelStepTitle.text = "Step \(index + 1)"

        if step.image.isEmpty {

            imageViewUploadedImage.image = UIImage(named: "CookBook_image_placholder_edit_dim")
        } else {

            imageViewUploadedImage.loadImage(step.image)
        }

        // imageViewUploadedImage.loadImage(step.image)

        textViewDescription.text = step.description
    }

    func setImage(with image: UIImage) {

        imageViewUploadedImage.image = image
    }

    private func setupTapGesture() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(openImageUploadMenu))

        imageViewUploadedImage.isUserInteractionEnabled = true

        imageViewUploadedImage.addGestureRecognizer(gesture)
    }

    @objc func openImageUploadMenu() {

        // open imageUpload Menu
        onUploadedImageTapped?()
    }
}

extension EditStepsCollectionViewCell: UITextViewDelegate {

    func textViewDidEndEditing(_ textView: UITextView) {

        guard let description = textView.text else { return }

        // 傳回去 EditSteps VC 本地 Steps 資料
        onDescriptionChanged?(description)
    }
}
