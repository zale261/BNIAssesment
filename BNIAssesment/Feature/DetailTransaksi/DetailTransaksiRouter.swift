//
//  DetailTransaksiRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation

import UIKit

protocol DetailTransaksiRouter {
    
}

class DetailTransaksiRouterImpl: DetailTransaksiRouter {

    static func createModule(with transactions: [DonutChart.DetailTransaksi.TransactionData]) -> UIViewController {
        let router = DetailTransaksiRouterImpl()
        let view = DetailTransaksiViewController()
        let interactor = DetailTransaksiInteractorImpl()
        let presenter = DetailTransaksiPresenter(transactions: transactions, router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
}
