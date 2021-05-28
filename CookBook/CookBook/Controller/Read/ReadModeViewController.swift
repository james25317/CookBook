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

    // var recipe: Recipe?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupCollecitonView()

        setupCollecitonViewFlowLayout()
    }

    @IBAction func leave(_ sender: Any) {

        dismiss(animated: true, completion: nil)
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

        // guard let recipe = recipe else { return 1 }

        guard let viewModel = viewModel,
            let recipe = viewModel.recipe else { return 1 }

        // total counts = steps counts + ingredients count(not yet)
        // return recipe.steps.count + 1

        return 1
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: String(describing: ReadStepsCollectionViewCell.self),
//            for: indexPath
//        )

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ReadIngredientsCollectionViewCell.self),
            for: indexPath
        )

        // guard let readStepCell = cell as? ReadStepsCollectionViewCell else { return cell }

        guard let readIngredientCell = cell as? ReadIngredientsCollectionViewCell else { return cell }

        guard let viewModel = viewModel,
            let recipe = viewModel.recipe else { return cell }

        readIngredientCell.viewModel = viewModel

        // readStepCell.layoutCell(with: recipe.steps[indexPath.row], at: indexPath.row, total: recipe.steps.count + 1)

        return readIngredientCell
    }
}

extension ReadModeViewController: UICollectionViewDelegate {

}
