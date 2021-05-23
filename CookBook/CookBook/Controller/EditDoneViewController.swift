//
//  EditDoneViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/5/18.
//

import UIKit

class EditDoneViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(true, animated: true)

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {

        navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewWillDisappear(animated)
    }

    @IBAction func shareFeedAndLeave(_ sender: Any) {

        // share on feed logic
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func shareFeedChallengeAndLeave(_ sender: Any) {

        // share on feed with challenge logic
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func backToHome(_ sender: Any) {

        // Try this way
        navigationController?.popToRootViewController(animated: true)

        // or this way
        // guard let homeVC = UIStoryboard.main.instantiateViewController(withIdentifier: "Home") as? HomeViewController else { return }

        // navigationController?.pushViewController(homeVC, animated: true)
    }
}