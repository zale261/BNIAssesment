//
//  HomePresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation

protocol HomePresenter: BasePresenter {
    
}

class HomePresenterImpl: HomePresenter {
    let router: HomeRouter
    let interactor: HomeInteractor
    weak var view: HomeView?
    
    init(router: HomeRouter, interactor: HomeInteractor, view: HomeView?) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
}
