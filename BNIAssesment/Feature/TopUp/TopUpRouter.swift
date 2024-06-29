//
//  TopUpRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit

protocol TopUpRouter {
    func popUpModule()
}

class TopUpRouterImpl: TopUpRouter {

    static func createModule() -> UIViewController {
        let router = TopUpRouterImpl()
        let view = TopUpViewController()
        let interactor = TopUpInteractorImpl()
        let presenter = TopUpPresenter(router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
    func popUpModule() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}
