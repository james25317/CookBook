//
//  SignInViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import Foundation

class SignInViewModel {

    let userViewModel: Box<UserViewModel?> = Box(nil)

    // init user
    var user = User(
        id: "",
        name: "CookBookUser",
        portrait: "",
        email: "",
        challengesCounts: 0,
        favoritesCounts: 0,
        recipesCounts: 0,
        blockList: []
    )

    var onGranteed: (() -> Void)?
    
    func createUserData(user: User, uid: String) {

        UserManager.shared.createUser(user: user, uid: uid) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("User: \(documentId) created")

                self?.onGranteed?()

            case .failure(let error):

                print("\(error), create user fail")

                CBProgressHUD.showFailure(text: "SignIn Fail")
            }
        }
    }
}
