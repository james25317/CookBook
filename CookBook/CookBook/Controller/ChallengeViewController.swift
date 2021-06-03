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

        // fetch this recipe for checking is challenger field is empty, if not, alert sign pops (and go back).
        
        // go create Recipe
        guard let editVC = UIStoryboard.edit
            .instantiateViewController(withIdentifier: "EditName") as? EditViewController else { return }

        navigationController?.pushViewController(editVC, animated: true)
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
