//
//  ChallengeViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/19.
//

import UIKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var imageViewPortrait: UIImageView!

    @IBOutlet weak var labelOwnerName: UILabel!

    @IBOutlet weak var labelLikesCounts: UILabel!

    @IBOutlet weak var imageViewRecipeMainImage: UIImageView!
    
    @IBOutlet weak var labelRecipeName: UILabel!

    let viewModel = ReadViewModel()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.onGranteed = { [weak self] () in

            guard let recipeId = self?.viewModel.recipeId,
                let selectedFeed = self?.viewModel.selectedFeed,
                let feedId = selectedFeed.id else { return }

            let uid = UserManager.shared.uid

            self?.viewModel.updateFeedStatus(feedId: feedId, uid: uid)

            self?.viewModel.updateRecipeStatus(recipeId: recipeId, uid: uid)

            guard let editVC = UIStoryboard.edit
                .instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }

            editVC.viewModel.recipe.challenger = uid

            editVC.viewModel.feedId = feedId

            CBProgressHUD.showSuccess(text: "Challenge Assigned")
            
            self?.navigationController?.pushViewController(editVC, animated: true)

            print("Challenge assigned")
        }

        viewModel.onDenied = { () in

            CBProgressHUD.showFailure(text: "Challenge Has Been Assigned")

            print("Challenger has been assigned")
        }

        viewModel.onReturned = { [weak self] () in

            guard let navigationController = self?.navigationController,
                let homeVC = navigationController.viewControllers.first(
                    where: { $0 is HomeViewController }
                ) else { return }

            navigationController.popToViewController(homeVC, animated: true)
        }

        viewModel.recipeViewModel.bind { [weak self] recipeViewModel in

            guard let recipeViewModel = recipeViewModel,
                let selectedFeed = self?.viewModel.selectedFeed else { return }

            if recipeViewModel.recipe.mainImage.isEmpty {

                self?.imageViewRecipeMainImage.image = UIImage(named: "CookBook_image_placholder_food_dim")
            } else {

                self?.imageViewRecipeMainImage.loadImage(recipeViewModel.recipe.mainImage)
            }

            if selectedFeed.portrait.isEmpty {

                self?.imageViewPortrait.image = UIImage(named: "CookBook_image_placholder_portrait_dim")
            } else {

                self?.imageViewPortrait.loadImage(selectedFeed.portrait)
            }

            self?.labelRecipeName.text = recipeViewModel.recipe.name

            self?.labelLikesCounts.text = String(describing: recipeViewModel.recipe.likes)
        }

        guard let recipeId = self.viewModel.recipeId else { return }

        viewModel.fetchRecipe(reciepeId: recipeId)

        layoutOwnerInfo()

        setupTapGesture()
    }

    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func goEditRecipe(_ sender: Any) {
        
        // fetch this recipe for checking is challenger field is empty, if not, alert sign pops (and go back).
        guard let recipeId = self.viewModel.recipeId else { return }

        viewModel.checkRecipeValue(reciepeId: recipeId)
    }

    private func setupTapGesture() {

        let ownerRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(goReadPage))

        imageViewRecipeMainImage.isUserInteractionEnabled = true

        imageViewRecipeMainImage.addGestureRecognizer(ownerRecipeGesture)
    }

    func layoutOwnerInfo() {

        imageViewPortrait.loadImage(self.viewModel.selectedFeed?.portrait)

        labelOwnerName.text = self.viewModel.selectedFeed?.name
    }

    @objc func goReadPage() {

        print("OwnerRecipe tapped")

        // go ReadPage
        guard let readVC = UIStoryboard.read
            .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        // 取 recipeId (feed.recipeId)
        let recipeId = self.viewModel.recipeId

        // 傳 Id
        readVC.recipeId = recipeId

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.navigationController?.pushViewController(readVC, animated: true)
    }
}
