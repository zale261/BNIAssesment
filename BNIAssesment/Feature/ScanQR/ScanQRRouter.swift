//
//  ScanQRRouter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit

protocol ScanQRRouter {
    func routeToPembayaran(with transaction: Transaksi)
    func popUpModule()
}

class ScanQRRouterImpl: ScanQRRouter {

    static func createModule() -> UIViewController {
        let router = ScanQRRouterImpl()
        let view = ScanQRViewController()
        let interactor = ScanQRInteractorImpl()
        let presenter = ScanQRPresenter(router: router, interactor: interactor, view: view)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    weak var viewController: UIViewController?
    
    func routeToPembayaran(with transaction: Transaksi) {
        let PembayaranVC = PembayaranRouterImpl.createModule(with: transaction)
        if var viewControllers = viewController?.navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(PembayaranVC)
            viewController?.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func popUpModule() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

