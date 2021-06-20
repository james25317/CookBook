//
//  CookBookFakeTests.swift
//  CookBookTests
//
//  Created by James Hung on 2021/6/20.
//

import XCTest
@testable import CookBook

class CookBookFakeTests: XCTestCase {

    var sut: UserManager!

    override func setUpWithError() throws {

        try super.setUpWithError()

        sut = UserManager.shared
    }

    override func tearDownWithError() throws {

        sut = nil
        
        try super.tearDownWithError()
    }

    func testFetchUserDataFromFirebaseCallBackParseData() {

        // let promise = expectation(description: "Parse in closure")

        let currentUid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        var currentUser = User(
            id: "",
            name: "CookBookUser",
            portrait: "",
            email: "james49904230@gmail.com",
            challengesCounts: 0,
            favoritesCounts: 2,
            recipesCounts: 2,
            blockList: ["8Y8ABmZAgdxtDoOPfmZq"]
        )

        sut.fetchUserData(uid: currentUid) { result in

            switch result {

            case .success(let user):

                XCTAssertEqual(currentUser, user)

                // promise.fulfill()

            case .failure(let error):

                XCTAssertNil(error.localizedDescription)
            }

            // self.wait(for: [promise], timeout: 10)
        }
    }
}
