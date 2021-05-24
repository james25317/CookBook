//
//  EditStepsPreviewViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/23.
//

import UIKit

class EditStepsPreviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    var viewModel: EditViewModel?

    override func viewDidLoad() {

        super.viewDidLoad()

        // 綁定顯示的資料組
        viewModel?.recipeViewModel.bind { [weak self] recipe in

            self?.tableView.reloadData()
        }

        setupTableView()
    }

    private func setupTableView() {

        tableView.registerCellWithNib(
            identifier: String(describing: EditStepsTableViewCell.self),
            bundle: nil
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let viewModel = viewModel else { return }

        if segue.identifier == "SegueEditSteps",
           let editStepsVC = segue.destination as? EditStepsViewController {

            // 傳 EditVM 過去
            editStepsVC.viewModel = viewModel
        }
    }
}

extension EditStepsPreviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let viewModel = viewModel,
            let data = viewModel.recipeViewModel.value else { return 0 }

        return data.steps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditStepsTableViewCell.self),
            for: indexPath
        )

        guard let stepsCell = cell as? EditStepsTableViewCell else { return cell }

        guard let recipeViewModel = viewModel?.recipeViewModel.value,
              indexPath.row < recipeViewModel.steps.count else { return cell }

        let step = recipeViewModel.steps[indexPath.row]

        stepsCell.layoutCell(with: step, at: indexPath.row)

        return stepsCell

    }

}

extension EditStepsPreviewViewController: UITableViewDelegate {

}
