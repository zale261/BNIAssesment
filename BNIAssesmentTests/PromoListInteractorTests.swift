//
//  PromoListInteractorTests.swift
//  BNIAssesmentTests
//
//  Created by MacBook on 28/06/2024.
//

import XCTest
@testable import BNIAssesment
import RxSwift

class PromoListInteractorTests: XCTestCase {
    var interactor: PromoListInteractor!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        interactor = PromoListInteractorImpl()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        interactor = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchPromos() {
        let expectation = self.expectation(description: "Fetch promos success")
        interactor.fetchPromos()
            .subscribe(onSuccess: { promos in
                XCTAssertNotNil(promos)
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Expected success but got error \(error)")
            }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
