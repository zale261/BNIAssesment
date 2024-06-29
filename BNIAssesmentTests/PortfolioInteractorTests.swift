//
//  PortfolioInteractorTests.swift
//  BNIAssesmentTests
//
//  Created by MacBook on 29/06/2024.
//

import XCTest
@testable import BNIAssesment

class PortfolioInteractorImplTests: XCTestCase {

    private var interactor: PortfolioInteractorImpl!
    
    override func setUp() {
        super.setUp()
        interactor = PortfolioInteractorImpl()
    }

    func testFetchPortfolio_Success() {
        // Lakukan fetch portfolio
        let portfolioData = interactor.fetchPortfolio()

        // Pastikan data portfolio tidak nil
        XCTAssertNotNil(portfolioData)
    }
}
