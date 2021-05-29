//
//  ReadModeViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class ReadModeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {

            self.collectionView.delegate = self

            self.collectionView.dataSource = self
        }
    }

    // CustomFlow Layout Outlet
    @IBOutlet weak var snapCollectionFlowLayout: SnapCollectionFlowLayout!

    var viewModel: ReadViewModel?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupCollecitonView()

        setupCollecitonViewFlowLayout()
    }

    @IBAction func leave(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func returnToFirstPage(_ sender: Any) {

        // scroll on top
        collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

    @IBAction func saveToFavorites(_ sender: Any) {

        // 1. prevent double likes logic (with UserDocumentId check)

        // "UserDocumentId" after sign in with store
        // In ProfilePage's Favorites sections, query Fb for Recipe that has my "UserDocumentId"

        guard let viewModel = viewModel,
              let recipe = viewModel.recipe,
              let documentId = recipe.id else { return }

        // 2. update +1 to "likes" table
        viewModel.updateLikes(with: documentId) { [weak self] result in

            switch result {

            case .success(_):

                print("Likes increased!")

            case .failure(let error):

                print(error)
            }
        }

        // 3. update favoritesUserId
        viewModel.updatefavoritesUserId(with: documentId, favoritesUserId: "UserDocumentId") { result in

            switch result {

            case .success(_):

                print("FavoritesUserId updated!")

            case .failure(let error):

                print(error)
            }
        }
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
}

extension ReadModeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let viewModel = viewModel,
              let recipe = viewModel.recipe else { return 1 }

        // total counts = steps counts + ingredients count
        return recipe.steps.count + 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row == 0 {

            // go readStepCell
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ReadIngredientsCollectionViewCell.self),
                for: indexPath
            )

            guard let readIngredientCell = cell as? ReadIngredientsCollectionViewCell else { return cell }

            guard let viewModel = viewModel,
                let recipe = viewModel.recipe else { return cell }

            readIngredientCell.viewModel = viewModel

            readIngredientCell.layoutCell(with: recipe)

            return readIngredientCell

        } else {

            // go readIngredientCell
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ReadStepsCollectionViewCell.self),
                for: indexPath
            )

            guard let readStepCell = cell as? ReadStepsCollectionViewCell else { return cell }

            guard let viewModel = viewModel,
                  let recipe = viewModel.recipe else { return cell }

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
