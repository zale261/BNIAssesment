//
//  RiwayatTransaksiPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa


class RiwayatTransaksiPresenter: BasePresenter {
    private let view: RiwayatTransaksiView
    private let interactor: RiwayatTransaksiInteractor
    private let router: RiwayatTransaksiRouter
    
    private let displayHistoryRelay = BehaviorRelay<[Transaksi]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(router: RiwayatTransaksiRouter, interactor: RiwayatTransaksiInteractor, view: RiwayatTransaksiView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestHistory: Observable<Void>
    }
    
    struct Output {
        let displayHistory: Driver<[Transaksi]>
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
        let history = interactor.fetchHistory()
        self.displayHistoryRelay.accept(history)
    }
}
