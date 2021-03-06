//
//  EditIngredientsViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditIngredientsViewController: UIViewController {

    @IBOutlet weak var textFieldingredientName: UITextField! {

        didSet {

            textFieldingredientName.delegate = self
        }
    }

    @IBOutlet weak var textFieldAmount: UITextField! {

        didSet {

            textFieldAmount.delegate = self
        }
    }

    @IBOutlet weak var textFieldUnit: UITextField! {

        didSet {

            textFieldUnit.delegate = self
        }
    }

    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.delegate = self

            tableView.dataSource = self

            if ingredients != nil {

                tableView.reloadData()
            }
        }
    }

    @IBOutlet weak var buttonAdd: UIButton!

    var viewModel: EditViewModel? {

        didSet {

            guard let viewModel = viewModel else { return }

            ingredients = viewModel.recipeViewModel.value?.ingredients
        }
    }

    // Local ingredients Struct
    var ingredients: [Ingredient]? {

        didSet {

            if let tableView = tableView {

                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        buttonAdd.isEnabled = false

        setupTableView()
    }

    @IBAction func leave(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    @IBAction func onIngredientNameChanged(_ sender: UITextField) {

        guard let name = sender.text, let viewModel = viewModel else { return }

        viewModel.onIngredientNameChanged(text: name)
    }

    @IBAction func onAmountChanged(_ sender: UITextField) {

        guard let amount = sender.text, let viewModel = viewModel else { return }

        viewModel.onAmountChanged(text: Int(amount) ?? 0)
    }

    @IBAction func onUnitChanged(_ sender: UITextField) {

        guard let unit = sender.text, let viewModel = viewModel else { return }

        viewModel.onUnitChanged(text: unit)
    }

    @IBAction func onTapAdd(_ sender: Any) {

        guard let viewModel = viewModel else { return }

        ingredients?.append(viewModel.ingredient)

        resetTextField()
    }

    @IBAction func onTapSave(_ sender: Any) {

        guard let viewModel = viewModel,
            let ingredients = ingredients else { return }

        viewModel.uploadIngredients(with: ingredients)

        CBProgressHUD.showSuccess(text: "Ingredients Added")

        dismiss(animated: true, completion: nil)
    }

    private func setupTableView() {

        tableView.registerCellWithNib(
            identifier: String(describing: EditIngredientsTableViewCell.self),
            bundle: nil
        )
    }

    private func resetTextField() {

        textFieldingredientName.text?.removeAll()

        textFieldAmount.text?.removeAll()

        textFieldUnit.text?.removeAll()
    }

    func deleteData(at index: Int) {

        ingredients?.remove(at: index)
    }
}

extension EditIngredientsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let ingredients = ingredients else { return 0 }

        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditIngredientsTableViewCell.self
            ), for: indexPath)

        guard let ingredientCell = cell as? EditIngredientsTableViewCell,
            let ingredients = ingredients else { return cell }

        let ingredient = ingredients[indexPath.item]

        ingredientCell.layoutCell(with: ingredient)

        ingredientCell.onDelete = { [weak self] in
            
            self?.deleteData(at: indexPath.item)
        }

        return ingredientCell
    }
}

extension EditIngredientsViewController: UITableViewDelegate {

}

extension EditIngredientsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let textFieldingredient = textFieldingredientName.text,
            let textFieldAmount = textFieldAmount.text,
            let textFieldUnit = textFieldUnit.text,
            !textFieldingredient.isEmpty,
            !textFieldAmount.isEmpty,
            !textFieldUnit.isEmpty
        else {

            buttonAdd.isEnabled = false

            return
        }

        buttonAdd.isEnabled = true
    }
}
