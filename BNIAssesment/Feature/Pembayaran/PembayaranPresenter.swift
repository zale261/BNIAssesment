//
//  PembayaranPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class PembayaranPresenter: BasePresenter {
    private let view: PembayaranView
    private let interactor: PembayaranInteractor
    private let router: PembayaranRouter
    
    private let displayTransactionRelay = BehaviorRelay<(Int, Transaksi?)>(value: (0, nil))
    private let displaySuccessRelay = BehaviorRelay<Int>(value: 0)
    private let displayFailureRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    private var transaction: Transaksi
    
    init(transaction: Transaksi, router: PembayaranRouter, interactor: PembayaranInteractor, view: PembayaranView) {
        self.transaction = transaction
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let requestTransaksi: Observable<Void>
        let requestPayment: Observable<Void>
        let popUpModule: Observable<Void>
    }
    
    struct Output {
        let displayTransaction: Driver<(Int, Transaksi?)>
        let displaySuccess: Driver<Int>
        let displayFailure: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displayTransaction: displayTransactionRelay.asDriver().skip(1),
            displaySuccess: displaySuccessRelay.asDriver().skip(1),
            displayFailure: displayFailureRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.requestTransaksi.subscribe(onNext: {[weak self] _ in
            self?.getTransaction()
        }).disposed(by: self.disposeBag)
        
        input.requestPayment.subscribe(onNext: {[weak self] _ in
            self?.requestPayment()
        }).disposed(by: self.disposeBag)
        
        input.popUpModule.subscribe(onNext: {[weak self] _ in
            self?.router.popUpModule()
        }).disposed(by: self.disposeBag)
    }
    
    private func getTransaction() {
        let saldo = interactor.fetchSaldo()
        self.displayTransactionRelay.accept((saldo, self.transaction))
    }
    
    private func requestPayment() {
        if let netBalance = interactor.requestPayment(for: self.transaction) {
            self.displaySuccessRelay.accept(netBalance)
        } else {
            self.displayFailureRelay.accept("Saldo-mu tidak mencukupi untuk melakukan pembayaran.")
        }
    }
}
