//
//  EditViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class EditViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
    }
    
    @IBAction func closePage(_ sender: Any) {

        navigationController?.popViewController(animated: true)
    }

    @IBAction func goPreviewPage(_ sender: Any) {

        guard let previewVC = storyboard?
            .instantiateViewController(withIdentifier: "EditPreview") as? EditPreviewViewController else { return }

        navigationController?.pushViewController(previewVC, animated: true)
    }
}
