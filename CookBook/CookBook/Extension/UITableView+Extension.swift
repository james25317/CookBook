//
//  UITableView+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/5/15.
//

import UIKit

extension UITableView {

  func registerCellWithNib(identifier: String, bundle: Bundle?) {

    let nib = UINib(nibName: identifier, bundle: bundle)
    register(nib, forCellReuseIdentifier: identifier)
    
  }

}
