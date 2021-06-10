//
//  EditDoneViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit
import Lottie

class EditDoneViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!

    var viewModel: EditViewModel?

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpAnimation()
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

        CBProgressHUD.showSuccess(text: "CookBook Shared")

        navigationController.popToViewController(homeVC, animated: true)
    }

    @IBAction func shareFeedChallengeAndLeave(_ sender: Any) {

        // share on feed with challenge logic
        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value?.recipe else { return }

        var feed = viewModel.convertRecipeToFeed(from: recipe, challengeOn: true)

        viewModel.createFeedData(with: &feed)

        // Useage: UserManager.shared.uid
        viewModel.updateChallengesCounts(with: UserManager.shared.uid)

        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        CBProgressHUD.showSuccess(text: "CookBook Shared")

        navigationController.popToViewController(homeVC, animated: true)
    }

    @IBAction func backToHome(_ sender: Any) {

        // share nothing, save to profile

        // Try this way
        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }

    func setUpAnimation() {

        let animeView = AnimationView()

        let anim = Animation.named("45730-recipes-book-animation", bundle: .main)

        animeView.frame = animationView.bounds

        animeView.contentMode = .scaleAspectFill

        animeView.animation = anim

        animeView.loopMode = .loop

        animeView.play()

        // animeView.play(fromProgress: 0, toProgress: 1)

        // animeView.play(fromMarker: "begin", toMarker: "end")

        animationView.addSubview(animeView)
    }
}
