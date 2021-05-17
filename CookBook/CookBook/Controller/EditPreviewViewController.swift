//
//  EditPreviewViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class EditPreviewViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func back(_ sender: Any) {

        navigationController?.popViewController(animated: true)
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave goes here

        // leave directly goes here
        navigationController?.popToRootViewController(animated: true)
    }
}
