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

        // given
        let currentUid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        let currentUser = User(
            id: "",
            name: "CookBookUser",
            portrait: "",
            email: "james49904230@gmail.com",
            challengesCounts: 0,
            favoritesCounts: 2,
            recipesCounts: 2,
            blockList: ["8Y8ABmZAgdxtDoOPfmZq"]
        )

        // when
        sut.fetchUserData(uid: currentUid) { result in

            switch result {

            case .success(let user):

                // then
                XCTAssertEqual(currentUser, user)

            case .failure(let error):

                XCTAssertNil(error.localizedDescription)
            }

        }
    }
}
