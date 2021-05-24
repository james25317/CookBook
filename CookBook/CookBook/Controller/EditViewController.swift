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

    let viewModel = EditViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTextView()
    }
    
    @IBAction func onNameChanged(_ sender: UITextField) {

        guard let name = sender.text else { return }

        viewModel.onNameChanged(text: name)
    }

    @IBAction func createCookBook(_ sender: Any) {

        // create Recipe, get documentId then fetch Recipe with it
        viewModel.createRecipe(with: &viewModel.recipe)

        // go EditPreview Page
        guard let previewVC = storyboard?
                .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

        navigationController?.pushViewController(previewVC, animated: true)

        // pass VM
        previewVC.viewModel = viewModel
    }

    @IBAction func closePage(_ sender: Any) {

        navigationController?.popViewController(animated: true)
    }

    func setupTextView() {

        textViewDescription.text = "請輸入食譜簡介"

        textViewDescription.textColor = UIColor.lightGray
    }
}

extension EditViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        guard let description = textView.text else { return }

        viewModel.onDescriptionChanged(text: description)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {

            textView.text = "請輸入食譜簡介"

            textView.textColor = UIColor.lightGray
        }
    }
}

extension EditViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "請輸入食譜簡介"

            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {

            textView.textColor = UIColor.black

            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {

            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }

}
