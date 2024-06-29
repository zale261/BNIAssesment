//
//  RiwayatTransaksiInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

protocol RiwayatTransaksiInteractor: BaseInteractor {
    func fetchHistory() -> [Transaksi]
}

class RiwayatTransaksiInteractorImpl: RiwayatTransaksiInteractor {
    
    func fetchHistory() -> [Transaksi] {
        return RiwayatTransaksiManager.shared.getRiwayatTransaksi()
    }
}
