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

class SignInViewController: UIViewController {

    @IBOutlet weak var buttonView: UIView!

    let viewModel = SignInViewModel()

    private var currentNonce: String?

    override func viewDidLoad() {

        super.viewDidLoad()

        viewModel.onGranteed = { [weak self] () in

            // 定義 SignIn 成功行為
            guard let todayVC = UIStoryboard.today
                .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }

            self?.navigationController?.pushViewController(todayVC, animated: true)
        }

        setupSignInButton()
    }

    @IBAction func skipSignIn(_ sender: Any) {

        guard let todayVC = UIStoryboard.today
                .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }

        self.navigationController?.pushViewController(todayVC, animated: true)
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

        // 將 request.nonce 套上 SHA 字串
        let nonce = randomNonceString()

        currentNonce = nonce

        request.nonce = sha256(nonce)

        // SignIn popup menu
        let controller = ASAuthorizationController(authorizationRequests: [request])

        controller.delegate = self

        controller.presentationContextProvider = self

        controller.performRequests()
    }

    private func randomNonceString(length: Int = 32) -> String {

        precondition(length > 0)

        let charset: Array<Character> =
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

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {

        let inputData = Data(input.utf8)

        let hashedData = SHA256.hash(data: inputData)

        let hashString = hashedData.compactMap { return String(format: "%02x", $0) } .joined()

        return hashString
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {

    //    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //
    //        // Firebase appleSignin handler
    //
    //        switch authorization.credential {
    //
    //        case let credentials as ASAuthorizationAppleIDCredential:
    //
    //            // ASAuthorizationAppleIDCredential -> UserInfo Object
    //            // 登入完成的回傳資料
    //            let signInUser = SignInUser(credentials: credentials)
    //
    //            // 回傳資料後的行為
    //            // UserVM 儲存
    //
    //            guard let todayVC = UIStoryboard.today
    //                    .instantiateViewController(withIdentifier: "Today") as? TodayViewController else { return }
    //
    //            navigationController?.pushViewController(todayVC, animated: true)
    //
    //        default:
    //
    //            break
    //        }
    //    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            // appleId callback data
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
            Auth.auth().signIn(with: credential) { authResult, error in

                if let error = error {

                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.

                    print(error.localizedDescription)

                    return

                } else {

                    // Firebase 回傳的 uid 用來作為生成新 User 的 DocumentId
                    guard let user = Auth.auth().currentUser else { return }

                    print("FirebaseUID: \(user.uid)")

                    print("UIDUser:\(user)")

                    // 儲存 Firebase uid 至 UserDefault
                    UserDefaults.standard.setValue(
                        user.uid,
                        forKey: UserDefaults.Keys.uid.rawValue
                    )

                    UserDefaults.standard.setValue(
                        user.email,
                        forKey: UserDefaults.Keys.email.rawValue
                    )

                    // 初始 User 資料
                    UserManager.shared.uid = user.uid

                    UserManager.shared.user.email = user.email ?? ""

                    self.viewModel.createUserData(user: UserManager.shared.user, uid: user.uid)
                }

            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return view.window!
    }
}
