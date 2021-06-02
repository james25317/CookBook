//
//  SceneDelegate.swift
//  CookBook
//
//  Created by James Hung on 2021/5/12.
//
// swiftlint:disable line_length

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard (scene as? UIWindowScene) != nil else { return }
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

        // 以暫存的 uuid 作爲登入判斷
        //        #if targetEnvironment(simulator)
        //
        //        UserDefaults.standard.setValue(
        //            "mockAppleId",
        //            forKey: UserDefaults.Keys.uid.rawValue
        //        )
        //
        //        UserDefaults.standard.setValue(
        //            "CookBookUser",
        //            forKey: UserDefaults.Keys.displayName.rawValue
        //        )
        //
        //        UserDefaults.standard.setValue(
        //            "testUser@.com",
        //            forKey: UserDefaults.Keys.email.rawValue
        //        )
        //
        //        if let todayVC = UIStoryboard.today.instantiateViewController(withIdentifier: "Today") as? TodayViewController {
        //
        //            window?.rootViewController = todayVC
        //        } else {
        //
        //            print("Can't initial today viewController")
        //        }
        //
        //        #else

        //        if let window = window?.rootViewController as? SignInViewController {
        //
        //            if let user = Auth.auth().currentUser {
        //
        //                UserDefaults.standard.setValue(
        //                    user.uid,
        //                    forKey: UserDefaults.Keys.uid.rawValue
        //                )
        //
        //                UserDefaults.standard.setValue(
        //                    user.displayName,
        //                    forKey: UserDefaults.Keys.displayName.rawValue
        //                )
        //
        //                UserDefaults.standard.setValue(
        //                    user.email,
        //                    forKey: UserDefaults.Keys.email.rawValue
        //                )
        //
        //                if let todayVC = UIStoryboard.today.instantiateInitialViewController(withIdentifier: "Today") as? TodayViewController {
        //
        //                    window?.rootViewController = todayVC
        //                } else {
        //
        //                    print("Can't initial today viewController")
        //                }
        //            }
        //        }

        //        #endif

        if let user = Auth.auth().currentUser {

            // user 存在 -> 進版頁
            let storyboard = UIStoryboard.today

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

            UserDefaults.standard.setValue(
                user.photoURL,
                forKey: UserDefaults.Keys.portrait.rawValue
            )

            window?.rootViewController = storyboard.instantiateInitialViewController()

            window?.makeKeyAndVisible()
        } else {

            // user 不存在 -> 登入頁
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
