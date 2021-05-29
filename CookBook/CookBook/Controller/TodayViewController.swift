//
//  TodayViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        let image = UIImage()

        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

        self.navigationController?.navigationBar.shadowImage = image
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // fetch 今日的資料

        setupTapGesture()
    }
    
    @IBAction func skipThisPage(_ sender: UIButton) {

        // comes from HomePage goes here
        // navigationController?.popViewController(animated: true)

        // comes from beginning goes here
        guard let homeVC = UIStoryboard.main
            .instantiateViewController(withIdentifier: "Home") as? HomeViewController else { return }

        navigationController?.pushViewController(homeVC, animated: true)
    }

    private func setupTapGesture() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(goTodayReadPage))

        recipeImageView.isUserInteractionEnabled = true

        recipeImageView.addGestureRecognizer(gesture)
    }

    @objc func goTodayReadPage() {

        guard let readVC = UIStoryboard.read
            .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        navigationController?.pushViewController(readVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
