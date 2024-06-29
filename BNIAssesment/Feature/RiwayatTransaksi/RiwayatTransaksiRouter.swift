//
//  RiwayatTransaksiRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit

protocol RiwayatTransaksiRouter {
    
}

class RiwayatTransaksiRouterImpl: RiwayatTransaksiRouter {

    static func createModule() -> UIViewController {
        let router = RiwayatTransaksiRouterImpl()
        let view = RiwayatTransaksiViewController()
        let interactor = RiwayatTransaksiInteractorImpl()
        let presenter = RiwayatTransaksiPresenter(router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
}
