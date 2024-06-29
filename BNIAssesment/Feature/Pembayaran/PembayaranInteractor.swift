//
//  PembayaranInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

protocol PembayaranInteractor: BaseInteractor {
    func requestPayment(for transaction: Transaksi) -> Int?
    func fetchSaldo() -> Int
}

class PembayaranInteractorImpl: PembayaranInteractor {
    
    func requestPayment(for transaction: Transaksi) -> Int? {
        let saldo = UserDefaults.standard.integer(forKey: "saldo")
        let nominal = transaction.nominal
        
        let netBalance = saldo - nominal
        
        guard netBalance >= 0 else { return nil }
        
        UserDefaults.standard.set(netBalance, forKey: "saldo")
        RiwayatTransaksiManager.shared.saveRiwayatTransaksi(transaction: transaction)
        
        return netBalance
    }
    
    func fetchSaldo() -> Int {
        let saldo = UserDefaults.standard.integer(forKey: "saldo")
        return saldo
    }
}
