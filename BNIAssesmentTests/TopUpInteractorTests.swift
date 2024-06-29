//
//  TopUpInteractorTests.swift
//  BNIAssesmentTests
//
//  Created by MacBook on 29/06/2024.
//

import XCTest
@testable import BNIAssesment

class TopUpInteractorImplTests: XCTestCase {

    private var interactor: TopUpInteractorImpl!
    
    override func setUp() {
        super.setUp()
        interactor = TopUpInteractorImpl()
    }

    func testRequestTopUp_Success() {
        // Atur saldo awal
        UserDefaults.standard.set(10000, forKey: "saldo")

        // Tentukan nilai top up
        let topUpValue = 50000

        // Lakukan request top up
        let newSaldo = interactor.requestTopUp(with: topUpValue)

        // Pastikan saldo yang dikembalikan sesuai dengan hasil penjumlahan
        XCTAssertEqual(newSaldo, 60000)

        // Pastikan saldo di UserDefaults diperbarui
        let updatedSaldo = UserDefaults.standard.integer(forKey: "saldo")
        XCTAssertEqual(updatedSaldo, 60000)
    }
}
