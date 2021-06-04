//
//  EditChallengeDoneViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/6/3.
//

import UIKit

class EditChallengeDoneViewController: UIViewController {

    var viewModel: EditViewModel?

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func shareBackToFeed(_ sender: Any) {
        
        // update Feed's data (recipeId)

        // back to homeFeed
        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }
}
