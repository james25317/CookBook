//
//  UIStoryboard+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

private enum StoryboardCategory: String {

    case main = "Main"

    case signIn = "SignIn"

    case today = "Today"

    case edit = "Edit"

    case editDone = "EditDone"

    case challenge = "Challenge"

    case profile = "Profile"

    case read = "Read"
}

extension UIStoryboard {

    static var main: UIStoryboard { return storyBoard(name: StoryboardCategory.main.rawValue) }

    static var signIn: UIStoryboard { return storyBoard(name: StoryboardCategory.signIn.rawValue) }

    static var today: UIStoryboard { return storyBoard(name: StoryboardCategory.today.rawValue) }
    
    static var edit: UIStoryboard { return storyBoard(name: StoryboardCategory.edit.rawValue) }

    static var editDone: UIStoryboard { return storyBoard(name: StoryboardCategory.editDone.rawValue) }

    static var challenge: UIStoryboard { return storyBoard(name: StoryboardCategory.challenge.rawValue) }

    static var profile: UIStoryboard { return storyBoard(name: StoryboardCategory.profile.rawValue) }

    static var read: UIStoryboard { return storyBoard(name: StoryboardCategory.read.rawValue) }

    private static func storyBoard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }

    static func getViewController(for viewControllerCategory: ViewControllerCategory) -> UIViewController {

        var controller: UIViewController

        switch viewControllerCategory {

        case .editDone:

            controller = UIStoryboard.editDone
                .instantiateViewController(withIdentifier: viewControllerCategory.rawValue)

        case .editName:

            controller = UIStoryboard.edit
                .instantiateViewController(withIdentifier: viewControllerCategory.rawValue)

        case .profile:

            controller = UIStoryboard.profile
                .instantiateViewController(withIdentifier: viewControllerCategory.rawValue)

        case .read:

            controller = UIStoryboard.read
                .instantiateViewController(withIdentifier: viewControllerCategory.rawValue)

        case .today:

            controller = UIStoryboard.today
                .instantiateViewController(withIdentifier: viewControllerCategory.rawValue)

        case .challenge:

            controller = UIStoryboard.challenge
                .instantiateViewController(withIdentifier: viewControllerCategory.rawValue)
        }

        return controller
    }
}
