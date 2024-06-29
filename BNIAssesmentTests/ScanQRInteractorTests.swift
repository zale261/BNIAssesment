//
//  ScanQRInteractorTests.swift
//  BNIAssesmentTests
//
//  Created by MacBook on 29/06/2024.
//

import XCTest
@testable import BNIAssesment

class ScanQRInteractorTests: XCTestCase {

    var interactor: ScanQRInteractorImpl!

    override func setUp() {
        super.setUp()
        interactor = ScanQRInteractorImpl()
    }

    override func tearDown() {
        interactor = nil
        super.tearDown()
    }

    func testGetTransactionValidString() {
        let validString = "BankA.12345.MerchantA.1000"
        let transaction = interactor.getTransaction(from: validString)
        
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction?.bank, "BankA")
        XCTAssertEqual(transaction?.id, "12345")
        XCTAssertEqual(transaction?.merchant, "MerchantA")
        XCTAssertEqual(transaction?.nominal, 1000)
    }
    
    func testGetTransactionInvalidStringLessComponents() {
        let invalidString = "BankA.12345.MerchantA"
        let transaction = interactor.getTransaction(from: invalidString)
        
        XCTAssertNil(transaction)
    }
    
    func testGetTransactionEmptyBank() {
        let invalidString = ".12345.MerchantA.1000"
        let transaction = interactor.getTransaction(from: invalidString)
        
        XCTAssertNil(transaction)
    }

    func testGetTransactionEmptyId() {
        let invalidString = "BankA..MerchantA.1000"
        let transaction = interactor.getTransaction(from: invalidString)
        
        XCTAssertNil(transaction)
    }
    
    func testGetTransactionEmptyMerchant() {
        let invalidString = "BankA.12345..1000"
        let transaction = interactor.getTransaction(from: invalidString)
        
        XCTAssertNil(transaction)
    }

    func testGetTransactionEmptyNominal() {
        let invalidString = "BankA.12345.MerchantA."
        let transaction = interactor.getTransaction(from: invalidString)
        
        XCTAssertNil(transaction)
    }
    
    func testGetTransactionNonNumericNominal() {
        let invalidString = "BankA.12345.MerchantA.nonNumeric"
        let transaction = interactor.getTransaction(from: invalidString)
        
        XCTAssertNil(transaction)
    }
}
