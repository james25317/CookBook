//
//  UINavigationController+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/6/21.
//

import UIKit

extension UINavigationController {

    enum ViewController: String {

        case today = "Today"

        case editName = "EditName"

        case profile = "Profile"
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
        }
    }
}
