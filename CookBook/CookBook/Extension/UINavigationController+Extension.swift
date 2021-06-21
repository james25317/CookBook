//
//  UINavigationController+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/6/21.
//

import UIKit

extension UINavigationController {

    func push(to viewControllerCategory: ViewControllerCategory) {

        switch viewControllerCategory {

        case .today:

            guard let todayVC =
                UIStoryboard.getViewController(for: .today) as? TodayViewController else { return }

            pushViewController(todayVC, animated: true)

        case .editName:

            guard let editVC =
                UIStoryboard.getViewController(for: .editName) as? EditViewController else { return }

            pushViewController(editVC, animated: true)

        case .profile:

            guard let profileVC =
                UIStoryboard.getViewController(for: .profile) as? ProfileViewController else { return }

            pushViewController(profileVC, animated: true)

        case .read:

            guard let readVC =
                UIStoryboard.getViewController(for: .read) as? ReadViewController else { return }

            pushViewController(readVC, animated: true)

        case .editDone:

            guard let editDoneVC =
                UIStoryboard.getViewController(for: .editDone) as? EditDoneViewController else { return }

            pushViewController(editDoneVC, animated: true)

        case .challenge:

            guard let challengeVC =
                UIStoryboard.getViewController(for: .challenge) as? ChallengeViewController else { return }

            pushViewController(challengeVC, animated: true)
        }
    }
}
