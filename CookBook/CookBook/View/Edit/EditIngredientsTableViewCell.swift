//
//  IngredientsTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/15.
//

import UIKit

class EditIngredientsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!

    @IBOutlet weak var labelAmount: UILabel!

    @IBOutlet weak var labelUnit: UILabel!

    @IBOutlet weak var buttonDelete: UIButton!

    var viewModel: RecipeViewModel?

    override func awakeFromNib() {

        super.awakeFromNib()

        self.selectionStyle = .none
    }

    @IBAction func deleteIngredient(_ sender: UIButton) {

        print("Delete button pressed")
    }

    func setup(viewModel: RecipeViewModel, indexPath: IndexPath) {

        self.viewModel = viewModel

        layoutCell(indexPath: indexPath)
    }

    private func layoutCell(indexPath: IndexPath) {

        guard let viewModel = viewModel else { return }

        labelName.text = viewModel.ingredients[indexPath.item].name

        labelAmount.text = String(describing: viewModel.ingredients[indexPath.item].amount)

        labelUnit.text = viewModel.ingredients[indexPath.item].unit
    }
}
