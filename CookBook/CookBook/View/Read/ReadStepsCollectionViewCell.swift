//
//  ReadCollectionViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/14.
//

import UIKit

class ReadStepsCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {

        super.awakeFromNib()

        setupCellCardStyle()

        // Initialization code
    }

    private func setupCellCardStyle() {
        
        layer.cornerRadius = 8

        layer.borderWidth = 1

        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
}
