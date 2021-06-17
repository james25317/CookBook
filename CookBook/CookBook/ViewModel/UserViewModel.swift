//
//  UserViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/22.
//

import UIKit

class UserViewModel {
    
    var user: User

    init(model user: User) {
        self.user = user
    }
    
    var id: String {
        return user.id ?? ""
    }
    
    var name: String {
        return user.name
    }

    var portrait: String {
        return user.portrait
    }

    var email: String {
        return user.email
    }

    var challengesCounts: Int {
        return user.challengesCounts
    }

    var favoritesCounts: Int {
        return user.favoritesCounts
    }

    var recipesCounts: Int {
        return user.recipesCounts
    }

    var blockList: [String] {
        return user.blockList
    }
}
