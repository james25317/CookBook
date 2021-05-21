//
//  EditIngredientsPreviewViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/21.
//

import UIKit

class EditIngredientsPreviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

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

        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditIngredientsTableViewCell.self), for: indexPath)

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        // 更新Firebase上的資料至cell顯示

        return ingredientCell
    }
}

extension EditIngredientsPreviewViewController: UITableViewDelegate {

}
