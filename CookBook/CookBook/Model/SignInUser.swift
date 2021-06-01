//
//  AppleUser.swift
//  CookBook
//
//  Created by James Hung on 2021/6/1.
//

import Foundation
import AuthenticationServices

struct SignInUser {

    let id: String
    let firstName: String
    let lastName: String
    let email: String

    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
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
