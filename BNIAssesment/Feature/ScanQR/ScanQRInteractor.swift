//
//  ScanQRInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

protocol ScanQRInteractor: BaseInteractor {
    func getTransaction(from string: String) -> Transaksi?
}

class ScanQRInteractorImpl: ScanQRInteractor {
    func getTransaction(from string: String) -> Transaksi? {
        let stringArray = string.components(separatedBy: ".")
        
        guard stringArray.count == 4 else { return nil }
        
        let bank = stringArray[0]
        guard bank.count > 0 else { return nil }
        
        let id = stringArray[1]
        guard id.count > 0 else { return nil }
        
        let merchant = stringArray[2]
        guard merchant.count > 0 else { return nil }
        
        let nominalString = stringArray[3]
        guard nominalString.count > 0, let nominal = Int(nominalString) else { return nil }
        
        let transaction = Transaksi(
            bank: bank,
            id: id,
            merchant: merchant,
            nominal: nominal
        )
        
        return transaction
    }
}
