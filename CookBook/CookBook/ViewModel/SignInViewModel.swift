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

    // 到下一頁
    var onGranteed: (() -> Void)?

//    func fetchUserData(with uid: String) {
//
//        UserManager.shared.fetchUser(uid: uid) { [weak self] result in
//
//            switch result {
//
//            case .success(let user):
//
//                // fetch 成功，有此位使用者，assign 資料
//                // self?.setUser(user)
//
//                // 可去進版頁
//                // self?.onGranteed?()
//
//                break
//            case .failure(let error):
//
//                print("\(error), fetch user fail, creating new user now")
//
//                // 創新 User
//                guard let userViewModel = self?.userViewModel,
//                    let user = userViewModel.value?.user else { return }
//
//                self?.createUserData(user: user, uid: uid)
//            }
//        }
//    }
    
    func createUserData(user: User, uid: String) {

        UserManager.shared.createUser(user: user, uid: uid) { [weak self] result in

            switch result {

            case .success(_):

                // 可去進版頁
                self?.onGranteed?()

            case .failure(let error):

                print("\(error), create user fail")
            }
        }
    }

    func convertUserToViewModel(from user: User) -> UserViewModel {

        let viewModel = UserViewModel(model: user)

        return viewModel
    }

    func setUser(_ user: User) {

        userViewModel.value = convertUserToViewModel(from: user)
    }
}
