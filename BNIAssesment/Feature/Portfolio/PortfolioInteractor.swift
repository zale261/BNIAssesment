//
//  PortfolioInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

protocol PortfolioInteractor: BaseInteractor {
    func fetchPortfolio() -> [Portfolio]?
}

class PortfolioInteractorImpl: PortfolioInteractor {
    func fetchPortfolio() -> [Portfolio]? {
        guard let url = Bundle.main.url(forResource: "portfolio", withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Portfolio].self, from: data)
            
            return jsonData
            
        } catch {
            return nil
        }
    }
}
