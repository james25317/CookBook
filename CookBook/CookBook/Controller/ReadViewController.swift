//
//  ReadViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class ReadViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    @IBAction func goReadMode(_ sender: Any) {

        guard let readModeVC = storyboard?
            .instantiateViewController(withIdentifier: "ReadMode") as? ReadModeViewController else { return }

        present(readModeVC, animated: true, completion: nil)
    }
}
