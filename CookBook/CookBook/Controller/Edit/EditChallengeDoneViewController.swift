//
//  EditChallengeDoneViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/6/3.
//

import UIKit
import Lottie

class EditChallengeDoneViewController: UIViewController {

    var viewModel: EditViewModel?

    @IBOutlet weak var animationView: UIView!

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func shareBackToFeed(_ sender: Any) {

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value?.recipe,
            let feedId = viewModel.feedId, let recipeId = recipe.id else { return }

        viewModel.updateFeedChallengeStatus(
            documentId: feedId,
            recipeId: recipeId,
            mainImage: recipe.mainImage,
            recipeName: recipe.name
        )

        guard let navigationController = navigationController,
            let homeVC = navigationController.viewControllers.first(
                where: { $0 is HomeViewController }
            ) else { return }

        navigationController.popToViewController(homeVC, animated: true)
    }

    func setupAnimation() {

        let animeView = AnimationView()

        let anim = Animation.named("45726-recipes-animation", bundle: .main)

        animeView.frame = animationView.bounds

        animeView.contentMode = .scaleAspectFill

        animeView.animation = anim

        animeView.loopMode = .loop

        animeView.play()

        animationView.addSubview(animeView)
    }
}
