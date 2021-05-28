//
//  ReadIngredientsCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/14.
//

import UIKit

class ReadIngredientsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!

    override func awakeFromNib() {

        super.awakeFromNib()

        tableView.delegate = self

        tableView.dataSource = self

        tableView.registerCellWithNib(
            identifier: String(describing: EditIngredientsTableViewCell.self),
            bundle: nil
        )
    }
}

extension ReadIngredientsCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: EditIngredientsTableViewCell.self),
            for: indexPath
        )

        guard let ingredientCell = cell as? EditIngredientsTableViewCell else { return cell }

        return ingredientCell
    }

    
}

extension ReadIngredientsCollectionViewCell: UITableViewDelegate {

}
