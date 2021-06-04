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
    
    var recipeId: String?

    var selectedFeed: Feed?
    
    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.onGranteed = { [weak self] () in
            
            // 更新 挑戰者狀態
            guard let recipeId = self?.recipeId,
                let selectedFeed = self?.selectedFeed,
                let feedId = selectedFeed.id else { return }

            // mockuid
            let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

            // updateFeed
            self?.viewModel.updateFeedStatus(feedId: feedId, uid: uid)

            // updateRecipe
            self?.viewModel.updateRecipeStatus(recipeId: recipeId, uid: uid)
            
            print("Challenge assigned")

            // 再去 fetch 一次最新的 recipe
            // self?.viewModel.fetchRecipe(reciepeId: recipeId)

            // go create Recipe
            guard let editVC = UIStoryboard.edit
                .instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }

            editVC.viewModel.recipe.challenger = uid

            editVC.viewModel.feedId = feedId
            
            self?.navigationController?.pushViewController(editVC, animated: true)
        }

        viewModel.onDenied = { [weak self] () in

            // alert 提示
            print("Challenger has been assigned")
        }

        viewModel.onReturned = { [weak self] () in

            print("Redirect to homeVC")

            // back to homeVC and reloadData()
            guard let navigationController = self?.navigationController,
                let homeVC = navigationController.viewControllers.first(
                    where: { $0 is HomeViewController }
                ) else { return }

            navigationController.popToViewController(homeVC, animated: true)
        }

        viewModel.recipeViewModel.bind { [weak self] recipeViewModel in

            guard let recipeViewModel = recipeViewModel else { return }

            self?.imageViewRecipeMainImage.loadImage(recipeViewModel.recipe.mainImage)

            self?.labelRecipeName.text = recipeViewModel.recipe.name

            self?.labelLikesCounts.text = String(describing: recipeViewModel.recipe.likes)
        }

        guard let recipeId = recipeId else { return }

        viewModel.fetchRecipe(reciepeId: recipeId)

        layoutOwnerInfo()

        setupTapGesture()
    }

    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func goEditRecipe(_ sender: Any) {

        // let uid = UserManager.shared.uid
        // let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        // fetch this recipe for checking is challenger field is empty, if not, alert sign pops (and go back).
        guard let recipeId = self.recipeId else { return }

        viewModel.checkRecipeValue(reciepeId: recipeId)

        // if it was empty, sign uid(recipe.ownerId) to its recipe
        // guard let selectedFeed = selectedFeed else { return }

        // viewModel.updateChallenger(documentId: selectedFeed.recipeId, uid: uid)

        // go create Recipe
        // guard let editVC = UIStoryboard.edit.instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }

        // navigationController?.pushViewController(editVC, animated: true)
    }

    private func setupTapGesture() {

        let ownerRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(goReadPage))

        imageViewRecipeMainImage.isUserInteractionEnabled = true

        imageViewRecipeMainImage.addGestureRecognizer(ownerRecipeGesture)
    }

    func layoutOwnerInfo() {

        imageViewPortrait.loadImage(self.selectedFeed?.portrait)

        labelOwnerName.text = self.selectedFeed?.name

        roundedImageView()
    }

    private func roundedImageView() {

        imageViewPortrait.layer.cornerRadius = imageViewPortrait.frame.size.height / 2
    }

    @objc func goReadPage() {

        print("OwnerRecipe tapped")

        // go ReadPage
        guard let readVC = UIStoryboard.read
            .instantiateViewController(withIdentifier: "Read") as? ReadViewController else { return }

        // 取 recipeId (feed.recipeId)
        let recipeId = recipeId

        // 傳 Id
        readVC.recipeId = recipeId

        self.navigationController?.pushViewController(readVC, animated: true)
    }
}
