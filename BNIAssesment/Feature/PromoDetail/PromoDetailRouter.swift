//
//  PromoDetailRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit
import SafariServices

protocol PromoDetailRouter {
    func openDetailUrl(detailUrl: String?)
}

class PromoDetailRouterImpl: BaseRouter, PromoDetailRouter {
    
    static func createModule(with promo: Promo) -> UIViewController {
        let viewController = PromoDetailViewController()
        let interactor = PromoDetailInteractorImpl()
        let router = PromoDetailRouterImpl()
        let presenter = PromoDetailPresenter(promo: promo, router: router, interactor: interactor, view: viewController)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
    weak var viewController: UIViewController?
    
    func openDetailUrl(detailUrl: String?) {
        guard let detailUrl = detailUrl, let url = URL(string: detailUrl) else { return }
        let svc = SFSafariViewController(url: url)
        self.viewController?.present(svc, animated: true, completion: nil)
    }
}
