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

    private let uid = UserManager.shared.uid

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

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value?.recipe else { return }

        var feed = viewModel.convertRecipeToFeed(from: recipe, challengeOn: false)

        viewModel.createFeed(with: &feed)

        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(
                where: { $0 is HomeViewController }
            ) else { return }

        CBProgressHUD.showSuccess(text: "CookBook Shared")

        navigationController.popToViewController(homeVC, animated: true)
    }

    @IBAction func shareFeedChallengeAndLeave(_ sender: Any) {

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value?.recipe else { return }

        var feed = viewModel.convertRecipeToFeed(from: recipe, challengeOn: true)

        viewModel.createFeed(with: &feed)

        viewModel.updateChallengesCounts(with: uid)

        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(
                where: { $0 is HomeViewController }
            ) else { return }

        CBProgressHUD.showSuccess(text: "CookBook Shared")

        navigationController.popToViewController(homeVC, animated: true)
    }

    @IBAction func backToHome(_ sender: Any) {

        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(
                where: { $0 is HomeViewController }
            ) else { return }

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
        
        animationView.addSubview(animeView)
    }
}
