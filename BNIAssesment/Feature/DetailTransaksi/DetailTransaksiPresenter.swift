//
//  DetailTransaksiPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa


class DetailTransaksiPresenter: BasePresenter {
    private let view: DetailTransaksiView
    private let interactor: DetailTransaksiInteractor
    private let router: DetailTransaksiRouter
    
    private let displayHistoryRelay = BehaviorRelay<[DonutChart.DetailTransaksi.TransactionData]>(value: [])
    private let disposeBag = DisposeBag()
    
    private var transactions: [DonutChart.DetailTransaksi.TransactionData]
    
    init(transactions: [DonutChart.DetailTransaksi.TransactionData], router: DetailTransaksiRouter, interactor: DetailTransaksiInteractor, view: DetailTransaksiView) {
        self.transactions = transactions
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestHistory: Observable<Void>
    }
    
    struct Output {
        let displayHistory: Driver<[DonutChart.DetailTransaksi.TransactionData]>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displayHistory: self.displayHistoryRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestHistory.subscribe(onNext: {[weak self] _ in
            self?.requestHistory()
        }).disposed(by: self.disposeBag)
    }
    
    private func requestHistory() {
        self.displayHistoryRelay.accept(self.transactions)
    }
}
