//
//  TopUpViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class TopUpViewController: UIViewController, TopUpView {
    var presenter: TopUpPresenter!
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var topUpButton: UIButton!
    
    private let requestTopUpRelay = PublishRelay<Int>()
    private let popUpModuleRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
    }
    
    private func setupUI() {
        topUpButton.addTarget(self, action: #selector(didTapTopUpButton(_:)), for: .touchUpInside)
    }
    
    private func bindPresenter() {
        let input = TopUpPresenter.Input(
            requestTopUp: requestTopUpRelay.asObservable(),
            popUpModule: popUpModuleRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.topUpSuccess.drive(onNext: {[weak self] (saldo) in
            let alert = UIAlertController(
                title: "Success", message: "Top up berhasil saldo-mu sekarang Rp\(saldo).",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {[weak self] _ in
                self?.popUpModuleRelay.accept(())
            }))
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    @objc func didTapTopUpButton(_ sender: UIButton) {
        let topUpValue = Int(valueTextField.text ?? "") ?? 0
        
        if topUpValue > 0 {
            self.requestTopUpRelay.accept(topUpValue)
        }
    }
}
