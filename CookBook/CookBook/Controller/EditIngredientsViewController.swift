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

    var editViewModel = EditViewModel()

    var editIngredientsViewModel = EditIngredientsViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()

//        editViewModel.recipeViewModel.bind{ [weak self] recipe in
//
//            self?.tableView.reloadData()
//        }

        // 利用傳進來的 VM(含資料) 幫忙 fetchRecipe
        // editViewModel.fetchRecipeData()

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

        editIngredientsViewModel.onIngredientNameChanged(text: name)
    }

    @IBAction func onAmountChanged(_ sender: UITextField) {

        guard let amount = sender.text else { return }

        editIngredientsViewModel.onAmountChanged(text: Int(amount) ?? 0)
    }

    @IBAction func onUnitChanged(_ sender: UITextField) {

        guard let unit = sender.text else { return }

        editIngredientsViewModel.onUnitChanged(text: unit)
    }

    @IBAction func onTapAdd(_ sender: Any) {

        // Add Ingredient data to local VM
    }


    @IBAction func onTapSave(_ sender: Any) {

        editIngredientsViewModel.update(with: &editIngredientsViewModel.ingredients)
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

        // guard let data = editViewModel.recipeViewModel.value else { return 0 }

        // return data.ingredients.count

        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditIngredientsTableViewCell.self
        ), for: indexPath)

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        // 從 Fb 更新來的資料顯示，Edit 頁面的資料在本地加減後上傳
        // let cellViewModel = self.editViewModel.recipeViewModel.value

        return ingredientCell
    }
}

extension EditIngredientsViewController: UITableViewDelegate {

}
