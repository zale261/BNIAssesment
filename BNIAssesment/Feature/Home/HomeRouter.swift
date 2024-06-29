//
//  HomeRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit

protocol HomeRouter {
    func routeToScanQR()
    func routeToTopUp()
    func routeToRiwayatTransaksi()
    func routeToPromo()
    func routeToPortfolio()
}

class HomeRouterImpl: HomeRouter {
 
    static func createModule() -> UIViewController {
        let router = HomeRouterImpl()
        let view = HomeViewController()
        let interactor = HomeInteractorImpl()
        let presenter = HomePresenter(router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
    func routeToScanQR() {
        let scanQRVC = ScanQRRouterImpl.createModule()
        viewController?.navigationController?.pushViewController(scanQRVC, animated: true)
    }
    
    func routeToTopUp() {
        let topUpVC = TopUpRouterImpl.createModule()
        viewController?.navigationController?.pushViewController(topUpVC, animated: true)
    }
    
    func routeToRiwayatTransaksi() {
        let riwayatTransaksiVC = RiwayatTransaksiRouterImpl.createModule()
        viewController?.navigationController?.pushViewController(riwayatTransaksiVC, animated: true)
    }
    
    func routeToPromo() {
        let promoListVC = PromoListRouterImpl.createModule()
        viewController?.navigationController?.pushViewController(promoListVC, animated: true)
    }
    
    func routeToPortfolio() {
        let portfolioVC = PortfolioRouterImpl.createModule()
        viewController?.navigationController?.pushViewController(portfolioVC, animated: true)
    }
}
