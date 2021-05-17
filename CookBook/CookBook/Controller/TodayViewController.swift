//
//  TodayViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTapGesture()
    }
    
    @IBAction func skipThisPage(_ sender: UIButton) {

        // comes from HomePage goes here
        navigationController?.popViewController(animated: true)

        // comes from beginning goes here
    }

    private func setupTapGesture() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(goReadPage))

        recipeImageView.isUserInteractionEnabled = true

        recipeImageView.addGestureRecognizer(gesture)
    }

    @objc func goReadPage() {

        guard let readVC = UIStoryboard.read
            .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        navigationController?.pushViewController(readVC, animated: true)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
