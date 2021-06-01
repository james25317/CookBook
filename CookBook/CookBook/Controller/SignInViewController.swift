//
//  SignInViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {

    @IBOutlet weak var buttonView: UIView!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupSignInButton()
    }

    func setupSignInButton() {

        let appleSignInButton = ASAuthorizationAppleIDButton()

        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false

        buttonView.addSubview(appleSignInButton)

        // button already has intrinsic size, height setup no need
        NSLayoutConstraint.activate([
            appleSignInButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            appleSignInButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            appleSignInButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            appleSignInButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor)
        ])


    }
}
