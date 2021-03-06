//
//  SceneDelegate.swift
//  CookBook
//
//  Created by James Hung on 2021/5/12.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private(set) static var shared: SceneDelegate?

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard (scene as? UIWindowScene) != nil else { return }

        // 1. there is only one scene delegate.
        // 2. There is only one scene and one window.
        // 3. All view controllers in the app are all part of that one scene and its window.
        Self.shared = self
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

        if let user = Auth.auth().currentUser {

            // User exist -> Go to TodayPage
            let storyboard = UIStoryboard.today

            // Store back UserDefault's value
            UserDefaults.standard.setValue(
                user.uid,
                forKey: UserDefaults.Keys.uid.rawValue
            )

            UserDefaults.standard.setValue(
                user.email,
                forKey: UserDefaults.Keys.email.rawValue
            )

            // UserManager injection
            UserManager.shared.uid = user.uid

            UserManager.shared.user.email = user.email ?? ""

            CBProgressHUD.showSuccess(text: "Welcome Back")

            window?.rootViewController = storyboard.instantiateInitialViewController()

            window?.makeKeyAndVisible()
        } else {

            // User doesn't exist -> Go to SignInPage
            let storyboard = UIStoryboard.signIn

            window?.rootViewController = storyboard.instantiateInitialViewController()

            window?.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
