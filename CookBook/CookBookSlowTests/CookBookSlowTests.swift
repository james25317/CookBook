//
//  CookBookSlowTests.swift
//  CookBookSlowTests
//
//  Created by James Hung on 2021/6/19.
//

import XCTest
@testable import CookBook

class CookBookSlowTests: XCTestCase {

    var sut: UserManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = UserManager.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testFetchUserDataFromFirebaseCallBack() throws {

        // given
        let subbedUid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        // 1
        let promise = expectation(description: "Fetch User Success")

        // when
        sut.fetchUserData(uid: subbedUid) { result in

            // then
            switch result {

            case .success(_):

                promise.fulfill()

            case .failure(let error):

                XCTFail("error: \(error)")
            }
        }

        // 3
        wait(for: [promise], timeout: 1)
    }
}
