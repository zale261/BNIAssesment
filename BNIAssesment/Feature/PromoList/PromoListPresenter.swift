//
//  PromoListPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class PromoListPresenter: BasePresenter {
    private let view: PromoListView
    private let interactor: PromoListInteractor
    private let router: PromoListRouter
    
    private let displayPromosRelay = BehaviorRelay<[Promo]>(value: [])
    private let displayErrorRelay = BehaviorRelay<Error?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init(router: PromoListRouter, interactor: PromoListInteractor, view: PromoListView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestPromos: Observable<Void>
        let didSelectPromo: Observable<Promo>
    }
    
    struct Output {
        let displayPromos: Driver<[Promo]>
        let displayError: Driver<Error?>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displayPromos: self.displayPromosRelay.asDriver().skip(1),
            displayError: self.displayErrorRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestPromos.subscribe(onNext: {[weak self] _ in
            self?.requestPromos()
        }).disposed(by: self.disposeBag)
        
        input.didSelectPromo.subscribe(onNext: {[weak self] promo in
            self?.router.routeToPromoDetail(with: promo)
        }).disposed(by: disposeBag)
    }
    
    private func requestPromos() {
        interactor.fetchPromos()
            .subscribe(onSuccess: {[weak self] promos in
                self?.displayPromosRelay.accept(promos.promos)
            }, onFailure: {[weak self] error in
                self?.displayErrorRelay.accept(error)
            }).disposed(by: disposeBag)
    }
}
