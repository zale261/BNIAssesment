//
//  ScanQRPresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ScanQRPresenter: BasePresenter {
    private let view: ScanQRView
    private let interactor: ScanQRInteractor
    private let router: ScanQRRouter
    
    private let displayErrorRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    init(router: ScanQRRouter, interactor: ScanQRInteractor, view: ScanQRView) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
    
    struct Input {
        let didScanQR: Observable<String>
        let popUpModule: Observable<Void>
    }
    
    struct Output {
        let displayError: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        bindView(input)
        return Output(
            displayError: self.displayErrorRelay.asDriver().skip(1)
        )
    }
    
    private func bindView(_ input: Input) {
        input.didScanQR.subscribe(onNext: {[weak self] string in
            self?.getTransaction(from: string)
        }).disposed(by: self.disposeBag)
        
        input.popUpModule.subscribe(onNext: {[weak self] _ in
            self?.router.popUpModule()
        }).disposed(by: self.disposeBag)
    }
    
    private func getTransaction(from string: String) {
        let transaction = interactor.getTransaction(from: string)
        if let transaction = transaction {
            self.router.routeToPembayaran(with: transaction)
        } else {
            self.displayErrorRelay.accept("Format QR String Tidak Valid")
        }
    }
}
