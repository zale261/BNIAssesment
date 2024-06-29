//
//  PromoListRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit

protocol PromoListRouter {
    func routeToPromoDetail(with promo: Promo)
}

class PromoListRouterImpl: BaseRouter, PromoListRouter {
    
    static func createModule() -> UIViewController {
        let viewController = PromoListViewController()
        let interactor = PromoListInteractorImpl()
        let router = PromoListRouterImpl()
        let presenter = PromoListPresenter(router: router, interactor: interactor, view: viewController)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
    private weak var viewController: UIViewController?
    
    func routeToPromoDetail(with promo: Promo) {
        let promoDetailVC = PromoDetailRouterImpl.createModule(with: promo)
        viewController?.navigationController?.pushViewController(promoDetailVC, animated: true)
    }
}
