//
//  ReadIngredientsCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/14.
//

import UIKit

class ReadIngredientsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var labelRecipeName: UILabel!

    var viewModel: ReadViewModel?

    override func awakeFromNib() {

        super.awakeFromNib()

        setupTableView()
    }

    private func setupTableView() {

        tableView.delegate = self

        tableView.dataSource = self

        tableView.registerCellWithNib(
            identifier: String(describing: EditIngredientsTableViewCell.self),
            bundle: nil
        )
    }

    func layoutCell(with recipe: Recipe) {

        labelRecipeName.text = recipe.name
    }
}

extension ReadIngredientsCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value else { return 1 }

        return recipe.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditIngredientsTableViewCell.self),
            for: indexPath
        )

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        guard let viewModel = viewModel,
            let recipe = viewModel.recipeViewModel.value else { return cell }

        ingredientCell.buttonDelete.isHidden = true

        ingredientCell.layoutCell(with: recipe.ingredients[indexPath.row])

        return ingredientCell
    }
}

extension ReadIngredientsCollectionViewCell: UITableViewDelegate {

}
