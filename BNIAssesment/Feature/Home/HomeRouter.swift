//
//  HomeRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit

protocol HomeRouter {
    
}

class HomeRouterImpl: HomeRouter {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let router = HomeRouterImpl()
        let view = HomeViewController()
        let interactor = HomeInteractorImpl()
        let presenter = HomePresenterImpl(router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}

