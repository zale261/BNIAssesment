//
//  PortfolioRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit

protocol PortfolioRouter {
    func routeToDetailTransaction(with transactions: [DonutChart.DetailTransaksi.TransactionData])
}

class PortfolioRouterImpl: PortfolioRouter {
    
    static func createModule() -> UIViewController {
        let router = PortfolioRouterImpl()
        let view = PortfolioViewController()
        let interactor = PortfolioInteractorImpl()
        let presenter = PortfolioPresenter(router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
    func routeToDetailTransaction(with transactions: [DonutChart.DetailTransaksi.TransactionData]) {
        let detailTransaksiVC = DetailTransaksiRouterImpl.createModule(with: transactions)
        viewController?.navigationController?.pushViewController(detailTransaksiVC, animated: true)
    }
}
