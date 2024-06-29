//
//  Portfolio.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

enum Portfolio: Decodable {
    case donutChart(DonutChart)
    case lineChart(LineChart)
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(ItemType.self, forKey: .type)

        let singleContainer = try decoder.singleValueContainer()
        
        switch type {
        case .donutChart:
            self = .donutChart(try singleContainer.decode(DonutChart.self))
        case .lineChart:
            self = .lineChart(try singleContainer.decode(LineChart.self))
        }
    }
}

enum ItemType: String, Decodable {
    case donutChart
    case lineChart
}

struct DonutChart: BaseEntity {
    let type: String
    let data: [DetailTransaksi]
    
    struct DetailTransaksi: BaseEntity {
        let label: String
        let percentage: String
        let data: [TransactionData]

        struct TransactionData: BaseEntity {
            let trx_date: String
            let nominal: Int
        }
    }
}

struct LineChart: BaseEntity {
    let type: String
    let data: Month
    
    struct Month: BaseEntity {
        let month: [Int]
    }
}
