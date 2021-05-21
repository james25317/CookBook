//
//  EditIngredientsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditIngredientsViewController: UIViewController {

    @IBOutlet weak var textFieldingredientName: UITextField!

    @IBOutlet weak var textFieldAmount: UITextField!

    @IBOutlet weak var textFieldUnit: UITextField!

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    let viewModel = EditIngredientsViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTableView()
    }

    @IBAction func leave(_ sender: Any) {

        // save draft before leave logic
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addIngredientsData(_ sender: Any) {

    }

    @IBAction func saveAndLeave(_ sender: Any) {
        
        // uplaod before leave logic

        dismiss(animated: true, completion: nil)
    }

    @IBAction func onIngredientNameChanged(_ sender: UITextField) {

        guard let name = sender.text else { return }

        viewModel.onIngredientNameChanged(text: name)
    }

    @IBAction func onAmountChanged(_ sender: UITextField) {

        guard let amount = sender.text else { return }

        viewModel.onAmountChanged(text: Int(amount) ?? 0)
    }

    @IBAction func onUnitChanged(_ sender: UITextField) {

        guard let unit = sender.text else { return }

        viewModel.onUnitChanged(text: unit)
    }

    @IBAction func onTapAdd(_ sender: Any) {

        // Add Ingredient data to local VM
    }


    @IBAction func onTapSave(_ sender: Any) {

        viewModel.update(with: &viewModel.ingredients)
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

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditIngredientsTableViewCell.self
        ), for: indexPath)

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        // 獲取VM的資料（來自本地增減）至cell顯示

        return ingredientCell
    }
}

extension EditIngredientsViewController: UITableViewDelegate {

}
