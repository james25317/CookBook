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

    // let viewModel = SignInViewModel()

    fileprivate var currentNonce: String?

    var uid: String?

    var name: String?

    var email: String?

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

    private func performExistingAccountSetupFlows() {

        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]

        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)

        authorizationController.delegate = self

        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
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

        let hashString = hashedData.compactMap {

            return String(format: "%02x", $0)

        }.joined()

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
                    guard let uid = Auth.auth().currentUser?.uid,
                        let user = authResult?.user else { return }

                    print("\(user): \(uid)")

                    // self.name = user.displayName

                    // self.email = user.email

                    // self.uid = user.uid

                    // 儲存 Firebase uid 至 UserDefault
                    UserDefaults.standard.setValue(
                        user.uid,
                        forKey: UserDefaults.Keys.uid.rawValue
                    )

                    UserDefaults.standard.setValue(
                        user.displayName,
                        forKey: UserDefaults.Keys.displayName.rawValue
                    )

                    UserDefaults.standard.setValue(
                        user.email,
                        forKey: UserDefaults.Keys.email.rawValue
                    )
                    
                    // 儲存 Firebase uid 至 UserVM


                    // 創建新 User 上 Firebase
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
