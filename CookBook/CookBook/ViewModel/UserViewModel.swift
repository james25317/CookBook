//
//  UserViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/22.
//

import UIKit

class UserViewModel {
    
    var user: User

    var onDelete: (() -> Void)?

    init(model user: User) {

        self.user = user
    }

    var appleId: String {
        get {
            return user.appleId
        }
    }

    var name: String {
        get {
            return user.name
        }
    }

    var portrait: String {
        get {
            return user.portrait
        }
    }

    var email: String {
        get {
            return user.email
        }
    }

    var challengesCounts: Int {
        get {
            return user.challengesCounts
        }
    }

    var favoritesCounts: Int {
        get {
            return user.favoritesCounts
        }
    }

    var recipesCounts: Int {
        get {
            return user.recipesCounts
        }
    }
}
