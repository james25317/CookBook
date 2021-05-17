//
//  UIStoryboard+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/5/17.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let today = "Today"

    static let edit = "Edit"

    static let profile = "Profile"
}

extension UIStoryboard {

    static var main: UIStoryboard { return storyBoard(name: StoryboardCategory.main) }

    static var today: UIStoryboard { return storyBoard(name: StoryboardCategory.today) }

    static var edit: UIStoryboard { return storyBoard(name: StoryboardCategory.edit) }

    static var profile: UIStoryboard { return storyBoard(name: StoryboardCategory.profile) }

    private static func storyBoard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
