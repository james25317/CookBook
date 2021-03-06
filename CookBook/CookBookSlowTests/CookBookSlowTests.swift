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

    let networkMonitor = NetworkMonitor.shared

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

    func testFetchUserDataFromFirebaseCallBackSuccess() throws {

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
        wait(for: [promise], timeout: 5)
    }

    func testFetchUserDataFromFirebaseCallBackCompletes() throws {

        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test."
        )

        // given
        let subbedUid = "EkrSAora4PRxZ1H22ggj6UfjU6A3"

        let promise = expectation(description: "Invalid uid request")

        var resultError: Error?

        var resultUser: User?

        // when
        sut.fetchUserData(uid: subbedUid) { result in

            switch result {

            case .success(let user):

                resultUser = user

            case .failure(let error):

                resultError = error
            }

            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNotNil(resultUser)

        XCTAssertNil(resultError)
    }
}
