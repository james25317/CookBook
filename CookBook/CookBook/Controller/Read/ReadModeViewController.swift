//
//  ReadModeViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class ReadModeViewController: UIViewController {

    enum RecipeItems: Int {

        case ingredients = 0

        case steps
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {

            self.collectionView.delegate = self

            self.collectionView.dataSource = self
        }
    }

    @IBOutlet weak var buttonFavorites: UIButton!

    // CustomFlowLayout Outlet
    @IBOutlet weak var snapCollectionFlowLayout: SnapCollectionFlowLayout!

    var viewModel: ReadViewModel?

    private let uid = UserManager.shared.uid

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel?.recipeViewModel.bind { [weak self] recipeViewModel in

            guard let uid = self?.uid else { return }

            if recipeViewModel?.recipe.favoritesUserId.contains(uid) == true {

                self?.buttonFavorites.isSelected = true
            } else {

                self?.buttonFavorites.isSelected = false
            }
        }

        viewModel?.onBlocked = { [weak self] () in

            guard let navigationController = self?.navigationController,
                let homeVC = navigationController.viewControllers.first(
                    where: { $0 is HomeViewController }
                ) else { return }

            CBProgressHUD.showText(text: "CookBook Blocked")

            navigationController.popToViewController(homeVC, animated: true)
        }

        setupCollecitonView()

        setupCollecitonViewFlowLayout()
    }

    @IBAction func leave(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func returnToFirstPage(_ sender: Any) {

        collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

    @IBAction func saveToFavorites(_ sender: Any) {

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value else { return }

        if buttonFavorites.isSelected {

            buttonFavorites.isSelected = false

            viewModel.updateLikes(documentId: recipe.id, by: -1)

            viewModel.removeFavoritesUserId(documentId: recipe.id, favoritesUserId: uid)

            viewModel.decreaseFavoritesCounts(uid: uid)

        } else {

            buttonFavorites.isSelected = true

            viewModel.updateLikes(documentId: recipe.id, by: 1)

            viewModel.addFavoritesUserId(documentId: recipe.id, favoritesUserId: uid)

            viewModel.increaseFavoritesCounts(uid: uid)

            CBProgressHUD.showSuccess(text: "CookBook Saved")
        }
    }

    @IBAction func goOptionMenu(_ sender: Any) {

        setupOptionMenu()
    }

    private func setupCollecitonView() {

        collectionView.registerCellWithNib(
            identifier: String(describing: ReadStepsCollectionViewCell.self),
            bundle: nil
        )

        collectionView.registerCellWithNib(
            identifier: String(describing: ReadIngredientsCollectionViewCell.self),
            bundle: nil
        )

        collectionView.backgroundColor = .clear
    }

    private func setupCollecitonViewFlowLayout() {

        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 32)

        snapCollectionFlowLayout.scrollDirection = .horizontal
    }

    private func setupOptionMenu() {

        let controller = UIAlertController(
            title: "Option",
            message: nil,
            preferredStyle: .actionSheet
        )

        let blockAction = UIAlertAction(
            title: "Block",
            style: .destructive) { _ in

            self.addToBlockList()
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel)

        controller.addAction(blockAction)

        controller.addAction(cancelAction)

        present(controller, animated: true)
    }

    private func addToBlockList() {

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value else { return }

        if recipe.ownerId == uid {

            CBProgressHUD.showText(text: "You can not banned your own recipe")

            return
        } else {

            viewModel.updateBlockList(uid: uid, recipeId: recipe.id)
        }
    }
}

extension ReadModeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value else { return 1 }

        // total counts = steps counts + ingredients count
        return recipe.steps.count + 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let recipeItems = indexPath.row

        if recipeItems == RecipeItems.ingredients.rawValue {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ReadIngredientsCollectionViewCell.self),
                for: indexPath
            )

            guard let readIngredientCell = cell as? ReadIngredientsCollectionViewCell else { return cell }

            guard let viewModel = viewModel,
                let recipe = viewModel.recipeViewModel.value else { return cell }

            readIngredientCell.viewModel = viewModel

            readIngredientCell.layoutCell(with: recipe.recipe)

            return readIngredientCell

        } else {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ReadStepsCollectionViewCell.self),
                for: indexPath
            )

            guard let readStepCell = cell as? ReadStepsCollectionViewCell else { return cell }

            guard let viewModel = viewModel,
                let recipe = viewModel.recipeViewModel.value else { return cell }

            readStepCell.layoutCell(
                with: recipe.steps[indexPath.row - 1],
                at: indexPath.row,
                total: recipe.steps.count
            )

            return readStepCell
        }
    }
}

extension ReadModeViewController: UICollectionViewDelegate {

}
