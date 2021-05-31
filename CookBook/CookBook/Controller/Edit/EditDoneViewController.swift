//
//  EditDoneViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditDoneViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }

    var viewModel: EditViewModel?

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func shareFeedAndLeave(_ sender: Any) {

        // share on feed logic
        // convert recipe data to feed
        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value?.recipe else { return }

        // convert Recipe to Feed (VM's convert function)
        var feed = viewModel.convertRecipeToFeed(from: recipe, challengeOn: false)

        // create a Feed (VM's create Feed function)
        viewModel.createFeedData(with: &feed)

        // go back to HomeVC by checking HomeVC is in NC or not
        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }

    @IBAction func shareFeedChallengeAndLeave(_ sender: Any) {

        // share on feed with challenge logic
        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value?.recipe else { return }

        var feed = viewModel.convertRecipeToFeed(from: recipe, challengeOn: true)

        viewModel.createFeedData(with: &feed)

        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }

    @IBAction func backToHome(_ sender: Any) {

        // share nothing, save to profile

        // Try this way
        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }
}
