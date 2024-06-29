//
//  Transaksi.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

struct Transaksi: BaseEntity {
    let bank: String
    let id: String
    let merchant: String
    let nominal: Int
}
