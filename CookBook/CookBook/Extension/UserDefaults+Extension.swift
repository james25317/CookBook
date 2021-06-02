//
//  UserDefault+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import Foundation
import UIKit

extension UserDefaults {

    enum Keys: String {

        case uid

        case displayName

        case email

        case portrait
    }

    func getString(key: Keys) -> String? {

        return string(forKey: key.rawValue)
    }
}
