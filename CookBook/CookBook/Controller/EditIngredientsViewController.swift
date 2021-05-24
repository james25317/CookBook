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

            guard let ingredients = ingredients else { return }

            tableView.reloadData()
        }
    }

    @IBOutlet weak var buttonAdd: UIButton!

    // 將本地增減結果用 VM 的方法上傳
    var editIngredientsViewModel = EditIngredientsViewModel()

    var viewModel: EditViewModel? {

        didSet {

            guard let viewModel = viewModel else { return }

            ingredients = viewModel.recipeViewModel.value?.ingredients
        }
    }

    // 傳過來的 Struct 來做本地增減
    var ingredients: [Ingredient]? {

        didSet {

            guard let tableView = tableView else { return }

            tableView.reloadData()
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

    @IBAction func onIngredientNameChanged(_ sender: UITextField) {

        guard sender.text?.isEmpty == false else { return }

        guard let name = sender.text, let viewModel = viewModel else { return }

        viewModel.onIngredientNameChanged(text: name)
    }

    @IBAction func onAmountChanged(_ sender: UITextField) {

        guard sender.text?.isEmpty == false else { return }

        guard let amount = sender.text, let viewModel = viewModel else { return }

        viewModel.onAmountChanged(text: Int(amount) ?? 0)
    }

    @IBAction func onUnitChanged(_ sender: UITextField) {

        guard sender.text?.isEmpty == false else { return }

        guard let unit = sender.text, let viewModel = viewModel else { return }

        viewModel.onUnitChanged(text: unit)
    }

    @IBAction func onTapAdd(_ sender: Any) {

        guard let viewModel = viewModel else { return }

        // Add Ingredient data with VM's function (local)
        ingredients?.append(viewModel.ingredient)

        // reset 輸入框內容
        resetTextField()

        // reset VM's Ingredient
        resetIngredient()
    }


    @IBAction func onTapSave(_ sender: Any) {

        guard let viewModel = viewModel, let ingredients = ingredients else { return }

        // update local Ingredient struct
        viewModel.updateIngredients(with: ingredients)
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

    private func resetIngredient() {

        guard let viewModel = viewModel else { return }

        viewModel.ingredient = Ingredient(
            amount: 0,
            name: "",
            unit: ""
        )
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

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        // 用本地的 Ingredients 資料更新
        guard let ingredients = ingredients else { return cell }

        let ingredient = ingredients[indexPath.item]

        ingredientCell.layoutCell(with: ingredient)

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
            buttonAdd.isUserInteractionEnabled = false
            buttonAdd.isEnabled = false
            return
        }

        buttonAdd.isUserInteractionEnabled = true
        buttonAdd.isEnabled = true
    }
}
