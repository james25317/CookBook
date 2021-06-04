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

    @IBOutlet weak var labelNext: UILabel!

    @IBOutlet weak var buttonNext: UIButton!

    var viewModel = EditViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTextView()

        // for testing, disable for now
        // setupNextEntrance()
    }
    
    @IBAction func onNameChanged(_ sender: UITextField) {

        guard let name = sender.text else { return }

        viewModel.onNameChanged(text: name)
    }

    @IBAction func createCookBook(_ sender: Any) {

        // mockuid
        let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        // create Recipe, get documentId then fetch Recipe with it
        viewModel.createRecipeData(with: &viewModel.recipe, with: uid)

        // Increased Recipes counts
        viewModel.updateRecipesCounts(with: uid)

        // go EditPreview Page
        guard let previewVC = storyboard?
            .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

        // pass VM
        previewVC.viewModel = viewModel

        navigationController?.pushViewController(previewVC, animated: true)
    }

    @IBAction func closePage(_ sender: Any) {

        navigationController?.popViewController(animated: true)
    }

    func setupTextView() {

        textViewDescription.text = "請輸入食譜簡介"

        textViewDescription.textColor = UIColor.lightGray
    }

    func setupNextEntrance() {

        labelNext.isHidden = true

        buttonNext.isHidden = true
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

            textView.text = "請輸入食譜簡介"

            textView.textColor = UIColor.lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text

        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "請輸入食譜簡介"

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

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let name = textFieldName.text else { return }

        if name.isEmpty == true && textViewDescription.text.isEmpty == true {

            labelNext.isHidden = true

            buttonNext.isHidden = true
        } else {

            labelNext.isHidden = false

            buttonNext.isHidden = false
        }
    }
}
