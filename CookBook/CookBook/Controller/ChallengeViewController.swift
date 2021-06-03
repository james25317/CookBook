//
//  ChallengeViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/19.
//

import UIKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var imageViewHostPortrait: UIImageView!

    @IBOutlet weak var labelHostName: UILabel!

    @IBOutlet weak var labelLikesCounts: UILabel!

    @IBOutlet weak var imageViewRecipeMainImage: UIImageView!
    
    @IBOutlet weak var labelRecipeName: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func goEditRecipe(_ sender: Any) {

        // go create Recipe
        // fetch this recipe for checking is challenger field is empty, if not, alert sign pops (and go back).
    }
}
