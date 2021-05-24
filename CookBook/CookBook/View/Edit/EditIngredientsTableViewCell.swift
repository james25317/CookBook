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

    func layoutCell(with ingredient: Ingredient) {

        labelName.text = ingredient.name

        labelAmount.text = String(describing: ingredient.amount)

        labelUnit.text = ingredient.unit
    }
}
