//
//  EditStepsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditStepsViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave logic

        dismiss(animated: true, completion: nil)
    }
}
