//
//  EditViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField! {

        didSet {

            textFieldName.delegate = self
        }
    }

    @IBOutlet weak var textViewDescription: UITextView! {

        didSet {

            textViewDescription.delegate = self
        }
    }
    
    @IBOutlet weak var buttonNext: UIButton!

    var viewModel = EditViewModel()

    private let uid = UserManager.shared.uid

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTextView()
    }
    
    @IBAction func onNameChanged(_ sender: UITextField) {

        guard let name = sender.text else { return }

        viewModel.onNameChanged(text: name)
    }

    @IBAction func createCookBook(_ sender: Any) {

        if textFieldName.text?.isEmpty == true {

            CBProgressHUD.showText(text: "Please enter your CookBook name")
        } else {

            viewModel.createRecipe(with: &viewModel.recipe, with: uid)

            viewModel.increaseRecipesCounts(with: uid)

            guard let previewVC = storyboard?
                .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

            previewVC.viewModel = viewModel

            navigationController?.pushViewController(previewVC, animated: true)
        }
    }

    @IBAction func closePage(_ sender: Any) {

        navigationController?.popViewController(animated: true)
    }

    func setupTextView() {

        textViewDescription.text = "  Recipe description"

        textViewDescription.font = UIFont(name: "PingFang TC Regular", size: 17)

        textViewDescription.textColor = UIColor.lightGray
    }
}

extension EditViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        guard let description = textView.text else { return }

        viewModel.onIngredientsDescriptionChanged(text: description)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {

            textView.text = "  Recipe description"

            textView.textColor = UIColor.lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text

        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "  Recipe description"

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

extension EditViewController: UITextFieldDelegate {
    
}
