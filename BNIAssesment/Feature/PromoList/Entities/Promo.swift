//
//  Promo.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation

struct Promo: BaseEntity {
    let id: Int
    let name: String
    let images_url: String
    let detail: String
}

struct PromoList: BaseEntity {
    let promos: [Promo]
}

