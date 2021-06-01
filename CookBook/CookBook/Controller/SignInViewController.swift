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

        // performExistingAccountSetupFlows()
    }

    func setupSignInButton() {

        let appleSignInButton = ASAuthorizationAppleIDButton()

        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false

        appleSignInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)

        buttonView.addSubview(appleSignInButton)

        // Add to the buttonView, position locked.
        NSLayoutConstraint.activate([
            appleSignInButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            appleSignInButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            appleSignInButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            appleSignInButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor)
        ])
    }

    @objc private func didTapSignInButton() {

        let provider = ASAuthorizationAppleIDProvider()

        let request = provider.createRequest()

        request.requestedScopes = [.fullName, .email]

        // SignIn popup menu
        let controller = ASAuthorizationController(authorizationRequests: [request])

        controller.delegate = self

        controller.presentationContextProvider = self

        controller.performRequests()
    }

    private func performExistingAccountSetupFlows() {

        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]

        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)

        authorizationController.delegate = self

        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {

        case let credentials as ASAuthorizationAppleIDCredential:

            // ASAuthorizationAppleIDCredential -> UserInfo Object
            // 登入完成的回傳資料
            let signInUser = SignInUser(credentials: credentials)

            // 回傳資料後的行為

//            guard let todayVC = UIStoryboard.today
//                    .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }
//
//            navigationController?.pushViewController(todayVC, animated: true)

        default:

            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("Apple signIn fail, \(error)")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return view.window!
    }
}
