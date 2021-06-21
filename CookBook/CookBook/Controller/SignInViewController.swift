//
//  SignInViewController.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import JGProgressHUD
import FirebaseCrashlytics

class SignInViewController: UIViewController {

    @IBOutlet weak var buttonView: UIView!

    let viewModel = SignInViewModel()

    private var currentNonce: String?

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.onGranteed = { [weak self] () in

            guard let todayVC = UIStoryboard.today
                .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }

            todayVC.navigationController?.setNavigationBarHidden(true, animated: true)

            CBProgressHUD.showSuccess(text: "SignIn Success")

            self?.navigationController?.pushViewController(todayVC, animated: true)
        }

        setupSignInButton()

        // runCrashlyticsTest()
    }

    @IBAction func skipSignIn(_ sender: Any) {

        // ------ testing area

        // Crashlytics.crashlytics().log("Crash Button Tapped")

        // fatalError()

        UserManager.shared.uid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"
        
        UserManager.shared.user.email = "james49904230@gmail.com"
        
        // ------ testing area end

//        guard let todayVC = UIStoryboard.today
//            .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }
//
//        self.navigationController?.pushViewController(todayVC, animated: true)

        navigationController?.push(to: .today)

        CBProgressHUD.showText(text: "Welcome Back")
    }

    func setupSignInButton() {

        let appleSignInButton = ASAuthorizationAppleIDButton()

        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false

        appleSignInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)

        buttonView.addSubview(appleSignInButton)

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

        let nonce = randomNonceString()

        currentNonce = nonce

        request.nonce = sha256(nonce)

        let controller = ASAuthorizationController(authorizationRequests: [request])

        controller.delegate = self

        controller.presentationContextProvider = self

        controller.performRequests()
    }

    private func randomNonceString(length: Int = 32) -> String {

        precondition(length > 0)

        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        var result = ""

        var remainingLength = length

        while remainingLength > 0 {

            let randoms: [UInt8] = (0 ..< 16).map { _ in

                var random: UInt8 = 0

                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)

                if errorCode != errSecSuccess {

                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }

                return random
            }

            randoms.forEach { random in

                if remainingLength == 0 {

                    return
                }

                if random < charset.count {

                    result.append(charset[Int(random)])

                    remainingLength -= 1
                }
            }
        }

        return result
    }

    func runCrashlyticsTest() {

        Crashlytics.crashlytics().log("View Loaded")

        Crashlytics.crashlytics().setCustomValue(2021, forKey: "Year")

        Crashlytics.crashlytics().setCustomValue("Soham Paul", forKey: "Name")
        
        Crashlytics.crashlytics().setUserID("424801")
    }

    @available(iOS 13.0, *)
    private func sha256(_ input: String) -> String {

        let inputData = Data(input.utf8)

        let hashedData = SHA256.hash(data: inputData)

        let hashString = hashedData.compactMap { return String(format: "%02x", $0) } .joined()

        return hashString
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            guard let nonce = currentNonce else {

                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            guard let appleIDToken = appleIDCredential.identityToken else {

                print("Unable to fetch identity token")

                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {

                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")

                return
            }

            // Initialize a Firebase credential.（from appleId callback）
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )

            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { _, error in

                if let error = error {

                    print(error.localizedDescription)

                    return
                } else {

                    guard let user = Auth.auth().currentUser else { return }

                    print("FirebaseUID: \(user.uid)")

                    print("UIDUser:\(user)")

                    UserDefaults.standard.setValue(
                        user.uid,
                        forKey: UserDefaults.Keys.uid.rawValue
                    )

                    UserDefaults.standard.setValue(
                        user.email,
                        forKey: UserDefaults.Keys.email.rawValue
                    )

                    UserManager.shared.uid = user.uid

                    UserManager.shared.user.email = user.email ?? ""

                    guard let userUid = UserDefaults.standard.string(
                        forKey: UserDefaults.Keys.uid.rawValue
                    ) else { return }

                    self.viewModel.createUserData(user: UserManager.shared.user, uid: userUid)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("Sign in with Apple errored: \(error)")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return view.window ?? UIWindow()
    }
}
