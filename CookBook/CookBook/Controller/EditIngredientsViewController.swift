//
//  EditIngredientsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditIngredientsViewController: UIViewController {

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

    @IBAction func leave(_ sender: Any) {

        // save draft before leave logic
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAndLeave(_ sender: Any) {
        
        // uplaod before leave logic

        dismiss(animated: true, completion: nil)
    }

    private func setupTableView() {

        tableView.registerCellWithNib(
            identifier: String(describing: EditIngredientsTableViewCell.self),
            bundle: nil
        )
    }
}

extension EditIngredientsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditIngredientsTableViewCell.self), for: indexPath)

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        // 置換Firebase上的資料

        return ingredientCell
    }
}

extension EditIngredientsViewController: UITableViewDelegate {

}
