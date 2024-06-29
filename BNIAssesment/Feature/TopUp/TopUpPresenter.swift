//
//  TopUpPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class TopUpPresenter: BasePresenter {
    private let view: TopUpView
    private let interactor: TopUpInteractor
    private let router: TopUpRouter
    
    private let topUpSuccessRelay = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    init(router: TopUpRouter, interactor: TopUpInteractor, view: TopUpView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestTopUp: Observable<Int>
        let popUpModule: Observable<Void>
    }
    
    struct Output {
        let topUpSuccess: Driver<Int>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            topUpSuccess: self.topUpSuccessRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestTopUp.subscribe(onNext: {[weak self] value in
            self?.requestTopUp(with: value)
        }).disposed(by: self.disposeBag)
        
        input.popUpModule.subscribe(onNext: {[weak self] _ in
            self?.router.popUpModule()
        }).disposed(by: self.disposeBag)
    }
    
    private func requestTopUp(with value: Int) {
        let saldo = interactor.requestTopUp(with: value)
        self.topUpSuccessRelay.accept(saldo)
    }
}
