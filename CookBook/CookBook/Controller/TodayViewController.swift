//
//  TodayViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

class TodayViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipThisPage(_ sender: UIButton) {

        // comes from HomePage goes here
        navigationController?.popViewController(animated: true)

        // comes from beginning goes here
    }
}
