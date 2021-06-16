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

            textViewDescription.textColor = UIColor.lightGray
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

    func setupImage(with image: UIImage) {

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

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {

            textView.text = " Enter Steps Description"

            textView.textColor = UIColor.lightGray
        }

        guard let description = textView.text else { return }

        // 傳回去 EditSteps VC 本地 Steps 資料
        onDescriptionChanged?(description)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text

        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = " Enter Steps Description"

            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument
            )
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {

            textView.textColor = UIColor.black

            textView.text = text
        } else {

            return true
        }

        return false
    }
}
