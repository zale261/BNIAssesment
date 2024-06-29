//
//  RiwayatTransaksiInteractorTests.swift
//  BNIAssesmentTests
//
//  Created by MacBook on 29/06/2024.
//

import XCTest
@testable import BNIAssesment

class RiwayatTransaksiInteractorTests: XCTestCase {

    private var interactor: RiwayatTransaksiInteractorImpl!
    
    override func setUp() {
        super.setUp()
        interactor = RiwayatTransaksiInteractorImpl()
    }

    func testFetchHistory() {
        // Buat beberapa data transaksi dummy
        let transaction1 = Transaksi(bank: "BNI", id: "TEST001", merchant: "Testing Merch1", nominal: 10000)
        let transaction2 = Transaksi(bank: "BNI", id: "TEST002", merchant: "Testing Merch2", nominal: 20000)
        let transaction3 = Transaksi(bank: "BNI", id: "TEST003", merchant: "Testing Merch3", nominal: 30000)

        // Simpan data transaksi dummy ke RiwayatTransaksiManager
        RiwayatTransaksiManager.shared.saveRiwayatTransaksi(transaction: transaction1)
        RiwayatTransaksiManager.shared.saveRiwayatTransaksi(transaction: transaction2)
        RiwayatTransaksiManager.shared.saveRiwayatTransaksi(transaction: transaction3)

        // Lakukan fetch history
        let history = interactor.fetchHistory()

        // Pastikan jumlah data tidak kosong
        XCTAssertGreaterThan(history.count, 0)
    }
}
