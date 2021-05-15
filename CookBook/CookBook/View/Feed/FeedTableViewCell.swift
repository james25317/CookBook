//
//  FeedTableViewCell.swift
//  CookBook
//
//  Created by James Hung on 2021/5/13.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

  @IBOutlet weak var profile: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var createdTime: UILabel!

  @IBOutlet weak var recipeImage: UIImageView!

  @IBOutlet weak var recipeName: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}
