//
//  AppleUser.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import Foundation

struct SignInUser {

    let id: String
    let firstName: String
    let lastName: String
    let email: String
}

extension SignInUser: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
            ID: \(id)
            First Name: \(firstName)
            last Name: \(lastName)
            Email: \(email)
            """
    }
}
