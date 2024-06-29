//
//  PromoDetailPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation
import RxSwift
import RxCocoa


class PromoDetailPresenter: BasePresenter {
    private let view: PromoDetailView
    private let interactor: PromoDetailInteractor
    private let router: PromoDetailRouter
    
    private let displayPromoRelay = BehaviorRelay<Promo?>(value: nil)
    private let disposeBag = DisposeBag()
    
    private var promo: Promo
    
    init(promo: Promo, router: PromoDetailRouter, interactor: PromoDetailInteractor, view: PromoDetailView) {
        self.promo = promo
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestPromo: Observable<Void>
        let didTapDetail: Observable<Void>
    }
    
    struct Output {
        let displayPromo: Driver<Promo?>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displayPromo: self.displayPromoRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestPromo.subscribe(onNext: {[weak self] _ in
            self?.displayPromoRelay.accept(self?.promo)
        }).disposed(by: self.disposeBag)
        
        input.didTapDetail.subscribe(onNext: {[weak self] _ in
            self?.router.openDetailUrl(detailUrl: self?.promo.detail)
        }).disposed(by: self.disposeBag)
    }
}
