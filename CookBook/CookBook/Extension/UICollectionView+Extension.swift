//
//  UICollectionView+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/5/19.
//

import UIKit

extension UICollectionView {

    func registerCellWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forCellWithReuseIdentifier: identifier)
    }
}
