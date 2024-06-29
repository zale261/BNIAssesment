//
//  PortfolioPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class PortfolioPresenter: BasePresenter {
    private let view: PortfolioView
    private let interactor: PortfolioInteractor
    private let router: PortfolioRouter
    
    private let displayPortfolioRelay = BehaviorRelay<[Portfolio]?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init(router: PortfolioRouter, interactor: PortfolioInteractor, view: PortfolioView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestPortfolio: Observable<Void>
        let didSelectTransaction: Observable<DonutChart.DetailTransaksi>
    }
    
    struct Output {
        let displayPortfolio: Driver<[Portfolio]?>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displayPortfolio: self.displayPortfolioRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestPortfolio.subscribe(onNext: {[weak self] _ in
            self?.requestPortfolio()
        }).disposed(by: self.disposeBag)
        
        input.didSelectTransaction.subscribe(onNext: {[weak self] transaction in
            self?.router.routeToDetailTransaction(with: transaction.data)
        }).disposed(by: disposeBag)
    }
    
    private func requestPortfolio() {
        let portfolio = interactor.fetchPortfolio()
        self.displayPortfolioRelay.accept(portfolio)
    }
}
