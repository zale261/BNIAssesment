//
//  PembayaranRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit

protocol PembayaranRouter {
    func popUpModule()
}

class PembayaranRouterImpl: PembayaranRouter {

    static func createModule(with transaction: Transaksi) -> UIViewController {
        let router = PembayaranRouterImpl()
        let view = PembayaranViewController()
        let interactor = PembayaranInteractorImpl()
        let presenter = PembayaranPresenter(transaction: transaction, router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
    func popUpModule() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}
