//
//  UINavigationController+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/6/21.
//

import UIKit

extension UINavigationController {

    public enum ViewController: String {

        case today = "Today"

        case editName = "EditName"

        case editDone = "EditDone"

        case profile = "Profile"

        case read = "Read"
    }

    func push(to viewController: ViewController) {

        switch viewController {

        case .today:

            guard let todayVC = UIStoryboard.today
                .instantiateViewController(
                    withIdentifier: viewController.rawValue
                ) as? TodayViewController else { return }

            pushViewController(todayVC, animated: true)

        case .editName:

            guard let editVC = UIStoryboard.edit
                .instantiateViewController(
                    withIdentifier: viewController.rawValue
                ) as? EditViewController else { return }

            pushViewController(editVC, animated: true)

        case .profile:

            guard let profileVC = UIStoryboard.profile
                .instantiateViewController(
                    withIdentifier: viewController.rawValue
                ) as? ProfileViewController else { return }

            pushViewController(profileVC, animated: true)

        case .read:

            guard let readVC = UIStoryboard.read
                .instantiateViewController(
                    withIdentifier: viewController.rawValue
                ) as? ReadViewController else { return }

            pushViewController(readVC, animated: true)

        case .editDone:

            guard let editDoneVC = UIStoryboard.editDone
                .instantiateViewController(
                    withIdentifier: viewController.rawValue
                ) as? ReadViewController else { return }

            pushViewController(editDoneVC, animated: true)
        }
    }
}
