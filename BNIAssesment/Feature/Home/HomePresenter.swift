//
//  HomePresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class HomePresenter: BasePresenter {
    private let view: HomeView
    private let interactor: HomeInteractor
    private let router: HomeRouter
    
    private let displaySaldoRelay = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    init(router: HomeRouter, interactor: HomeInteractor, view: HomeView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestSaldo: Observable<Void>
        let didTapScanQR: Observable<Void>
        let didTapTopUp: Observable<Void>
        let didTapRiwayatTransaksi: Observable<Void>
        let didTapPromo: Observable<Void>
        let didTapPortfolio: Observable<Void>
    }
    
    struct Output {
        let displaySaldo: Driver<Int>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displaySaldo: self.displaySaldoRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestSaldo.subscribe(onNext: {[weak self] _ in
            self?.requestSaldo()
        }).disposed(by: self.disposeBag)
        
        input.didTapScanQR.subscribe(onNext: {[weak self] _ in
            self?.router.routeToScanQR()
        }).disposed(by: self.disposeBag)
        
        input.didTapTopUp.subscribe(onNext: {[weak self] _ in
            self?.router.routeToTopUp()
        }).disposed(by: self.disposeBag)
        
        input.didTapRiwayatTransaksi.subscribe(onNext: {[weak self] _ in
            self?.router.routeToRiwayatTransaksi()
        }).disposed(by: self.disposeBag)
        
        input.didTapPromo.subscribe(onNext: {[weak self] _ in
            self?.router.routeToPromo()
        }).disposed(by: self.disposeBag)
        
        input.didTapPortfolio.subscribe(onNext: {[weak self] _ in
            self?.router.routeToPortfolio()
        }).disposed(by: self.disposeBag)
    }
    
    private func requestSaldo() {
        let saldo = interactor.fetchSaldo()
        self.displaySaldoRelay.accept(saldo)
    }
}
