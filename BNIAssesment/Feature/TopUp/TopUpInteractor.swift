//
//  TopUpInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

protocol TopUpInteractor: BaseInteractor {
    func requestTopUp(with value: Int) -> Int
}

class TopUpInteractorImpl: TopUpInteractor {
    func requestTopUp(with value: Int) -> Int {
        var saldo = UserDefaults.standard.integer(forKey: "saldo")
        saldo += value
        UserDefaults.standard.set(saldo, forKey: "saldo")
        return saldo
    }
}
