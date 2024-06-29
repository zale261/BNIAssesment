//
//  PembayaranInteractorTests.swift
//  BNIAssesmentTests
//
//  Created by MacBook on 29/06/2024.
//

import XCTest
@testable import BNIAssesment

class PembayaranInteractorTests: XCTestCase {

    private var interactor: PembayaranInteractorImpl!
    
    override func setUp() {
        super.setUp()
        interactor = PembayaranInteractorImpl()
    }

    // Test untuk fungsi requestPayment
    func testRequestPayment_CukupSaldo() {
        // Atur saldo awal
        UserDefaults.standard.set(100000, forKey: "saldo")

        // Buat transaksi dengan nominal kurang dari saldo
        let transaction = Transaksi(bank: "BNI", id: "TEST001", merchant: "Testing Merch", nominal: 50000)

        // Mengambil data history payment sebelum melakukan request payment
        let savedTransactionsBefore = RiwayatTransaksiManager.shared.getRiwayatTransaksi()
        
        // Lakukan request payment
        let remainingBalance = interactor.requestPayment(for: transaction)
        
        // Menngambil data history payment sebelum melakukan request payment
        let savedTransactionsAfter = RiwayatTransaksiManager.shared.getRiwayatTransaksi()

        // Pastikan saldo yang dikembalikan sesuai dengan sisa saldo
        XCTAssertEqual(remainingBalance, 50000)

        // Pastikan saldo di UserDefaults diperbarui
        let updatedSaldo = UserDefaults.standard.integer(forKey: "saldo")
        XCTAssertEqual(updatedSaldo, 50000)
        
        // Pastikan riwayat pembayaran bertambah 1 data
        XCTAssertEqual(savedTransactionsAfter.count - savedTransactionsBefore.count, 1)
    }

    func testRequestPayment_SaldoTidakCukup() {
        // Atur saldo awal
        UserDefaults.standard.set(10000, forKey: "saldo")

        // Buat transaksi dengan nominal lebih dari saldo
        let transaction = Transaksi(bank: "BNI", id: "TEST001", merchant: "Testing Merch", nominal: 20000)
        
        // Mengambil data history payment sebelum melakukan request payment
        let savedTransactionsBefore = RiwayatTransaksiManager.shared.getRiwayatTransaksi()

        // Lakukan request payment
        let remainingBalance = interactor.requestPayment(for: transaction)
        
        // Menngambil data history payment sebelum melakukan request payment
        let savedTransactionsAfter = RiwayatTransaksiManager.shared.getRiwayatTransaksi()

        // Pastikan saldo yang dikembalikan nil
        XCTAssertNil(remainingBalance)

        // Pastikan saldo di UserDefaults tidak berubah
        let updatedSaldo = UserDefaults.standard.integer(forKey: "saldo")
        XCTAssertEqual(updatedSaldo, 10000)

        // Pastikan riwayat transaksi tidak disimpan
        XCTAssertEqual(savedTransactionsAfter.count - savedTransactionsBefore.count, 0)
    }

    // Test untuk fungsi fetchSaldo
    func testFetchSaldo() {
        // Atur saldo awal
        UserDefaults.standard.set(50000, forKey: "saldo")

        // Lakukan fetch saldo
        let fetchedSaldo = interactor.fetchSaldo()

        // Pastikan saldo yang dikembalikan sesuai dengan saldo di UserDefaults
        XCTAssertEqual(fetchedSaldo, 50000)
    }
}
