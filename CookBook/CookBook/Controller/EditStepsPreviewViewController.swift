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

        setupTableView()
    }

    private func setupTableView() {

        tableView.registerCellWithNib(
            identifier: String(describing: EditStepsTableViewCell.self),
            bundle: nil
        )
    }
}

extension EditStepsPreviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditStepsTableViewCell.self), for: indexPath)

        guard let ingredientCell = cell as? EditStepsTableViewCell else { return cell }

        // 更新Firebase上的資料至cell顯示

        return ingredientCell

    }

}

extension EditStepsPreviewViewController: UITableViewDelegate {

}
