//
//  EditViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!

    @IBOutlet weak var textViewDescription: UITextView! {

        didSet {

            textViewDescription.delegate = self
        }
    }

    let viewModel = EditViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()
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
}

extension EditViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        guard let description = textView.text else { return }

        viewModel.onDescriptionChanged(text: description)
    }
}
