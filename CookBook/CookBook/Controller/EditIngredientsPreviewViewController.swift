//
//  EditIngredientsPreviewViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/21.
//
//  ContainerView Preview - Ingredients

import UIKit

class EditIngredientsPreviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {

            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    var viewModel: EditViewModel?

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel?.recipeViewModel.bind { [weak self] recipe in

            self?.tableView.reloadData()
        }

        setupTableView()
    }

    private func setupTableView() {

        tableView.registerCellWithNib(
            identifier: String(describing: EditIngredientsTableViewCell.self),
            bundle: nil
        )
    }
}

extension EditIngredientsPreviewViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let viewModel = viewModel,
              let data = viewModel.recipeViewModel.value else { return 0 }

        return data.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditIngredientsTableViewCell.self), for: indexPath)

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        guard let viewModel = viewModel,
              let cellViewModel = viewModel.recipeViewModel.value else { return cell }

        // How can I arrange sequence?
        ingredientCell.setup(viewModel: cellViewModel, indexPath: indexPath)

        return ingredientCell
    }
}

extension EditIngredientsPreviewViewController: UITableViewDelegate {

}
