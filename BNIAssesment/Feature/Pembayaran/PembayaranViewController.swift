//
//  PembayaranViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class PembayaranViewController: UIViewController, PembayaranView {
    var presenter: PembayaranPresenter!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var nominalLabel: UILabel!
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var netBalanceLabel: UILabel!
    @IBOutlet weak var bayarButton: UIButton!
    
    private let requestTransaksiRelay = PublishRelay<Void>()
    private let requestPaymentRelay = PublishRelay<Void>()
    private let popUpModuleRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestTransaksiRelay.accept(())
    }
    
    private func setupUI() {
        title = "Detail Pembayaran"
        bayarButton.addTarget(self, action: #selector(didTapBayarButton(_:)), for: .touchUpInside)
    }
    
    private func bindPresenter() {
        let input = PembayaranPresenter.Input(
            requestTransaksi: self.requestTransaksiRelay.asObservable(),
            requestPayment: self.requestPaymentRelay.asObservable(),
            popUpModule: popUpModuleRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displayTransaction.drive(onNext: {[weak self] (saldo, transaction) in
            guard let transaction = transaction else { return }
            let netBalance = saldo - transaction.nominal
            self?.idLabel.text = transaction.id
            self?.merchantLabel.text = transaction.merchant
            self?.nominalLabel.text = "Rp\(transaction.nominal)"
            self?.saldoLabel.text = "Rp\(saldo)"
            self?.netBalanceLabel.text = "Rp\(netBalance)"
        }).disposed(by: self.disposeBag)
        
        output.displaySuccess.drive(onNext: {[weak self] saldo in
            let alert = UIAlertController(
                title: "Success", message: "Pembayaran berhasil saldo-mu sekarang Rp\(saldo).",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {[weak self] _ in
                self?.popUpModuleRelay.accept(())
            }))
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        output.displayFailure.drive(onNext: {[weak self] message in
            let alert = UIAlertController(
                title: "Error", message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    @objc func didTapBayarButton(_ sender: UIButton) {
        self.requestPaymentRelay.accept(())
    }
}
