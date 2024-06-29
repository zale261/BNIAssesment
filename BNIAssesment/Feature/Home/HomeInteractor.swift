//
//  HomeInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation

protocol HomeInteractor: BaseInteractor {
    func fetchSaldo() -> Int
}

class HomeInteractorImpl: HomeInteractor {
    func fetchSaldo() -> Int {
        let saldo = UserDefaults.standard.integer(forKey: "saldo")
        return saldo
    }
}
