//
//  EditChallengeDoneViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/6/3.
//

import UIKit

class EditChallengeDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareBackToFeed(_ sender: Any) {
        
        // update Feed's data (recipeId)

        // back to homeFeed
        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }
}
