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

        guard let name = sender.text else {
            return
        }

        viewModel.onNameChanged(text: name)
    }

    @IBAction func createCookBook(_ sender: Any) {

        viewModel.create(with: &viewModel.recipe)

        // go EditPreview Page
        guard let previewVC = storyboard?
            .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

        // pass VM & created DocumentId

        navigationController?.pushViewController(previewVC, animated: true)
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
