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

        // mockuid
        let uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value else { return }

        // 2. update +1 to "likes" table
        viewModel.updateLikes(with: recipe.id) { result in

            switch result {

            case .success(_):

                print("Likes increased!")

            case .failure(let error):

                print(error)
            }
        }

        // 3. update favoritesUserId
        viewModel.updateFavoritesUserId(recipeId: recipe.id, uid: uid) { result in

            switch result {

            case .success(_):

                print("FavoritesUserId updated!")

            case .failure(let error):

                print(error)
            }
        }

        // 4. update favoritesCounts
        viewModel.updateFavoritesCounts(uid: uid)
    }

    @IBAction func goOptionMenu(_ sender: Any) {

        // 打開選單欄位
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
            title: "選單",
            message: nil,
            preferredStyle: .actionSheet
        )

        let blockAction = UIAlertAction(
            title: "檢舉並封鎖",
            style: .destructive) { _ in

            // 開啟相機
            // self.openCamera()
        }

        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel)

        controller.addAction(blockAction)

        controller.addAction(cancelAction)

        present(controller, animated: true)
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

        if indexPath.row == 0 {

            // go readStepCell
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

            // go readIngredientCell
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
