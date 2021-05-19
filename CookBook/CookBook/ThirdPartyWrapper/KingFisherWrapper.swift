//
//  KingFisherWrapper.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import UIKit
import Kingfisher

extension UIImageView {

  func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
    guard urlString != nil else { return }
    let url = URL(string: urlString!)
    self.kf.setImage(with: url, placeholder: placeHolder)
  }
}
