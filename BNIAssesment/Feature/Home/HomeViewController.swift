//
//  HomeViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, HomeView {
    var presenter: HomePresenter!
    
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var scanQRButton: UIButton!
    @IBOutlet weak var topUpButton: UIButton!
    @IBOutlet weak var riwayatTransaksiButton: UIButton!
    @IBOutlet weak var promoButton: UIButton!
    @IBOutlet weak var portfolioButton: UIButton!
    
    private let requestSaldoRelay = PublishRelay<Void>()
    private let didTapScanQRRelay = PublishRelay<Void>()
    private let didTapTopUpRelay = PublishRelay<Void>()
    private let didTapRiwayatTransaksiRelay = PublishRelay<Void>()
    private let didTapPromoRelay = PublishRelay<Void>()
    private let didTapPortfolioRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestSaldoRelay.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestSaldoRelay.accept(())
    }
    
    private func setupUI() {
        scanQRButton.addTarget(self, action: #selector(didTapScanQRButton(_:)), for: .touchUpInside)
        topUpButton.addTarget(self, action: #selector(didTapTopUpButton(_:)), for: .touchUpInside)
        riwayatTransaksiButton.addTarget(self, action: #selector(didTapRiwayatTransaksiButton(_:)), for: .touchUpInside)
        promoButton.addTarget(self, action: #selector(didTapPromoButton(_:)), for: .touchUpInside)
        portfolioButton.addTarget(self, action: #selector(didTapPortfolioButton(_:)), for: .touchUpInside)
    }
    
    private func bindPresenter() {
        let input = HomePresenter.Input(
            requestSaldo: requestSaldoRelay.asObservable(),
            didTapScanQR: didTapScanQRRelay.asObservable(),
            didTapTopUp: didTapTopUpRelay.asObservable(),
            didTapRiwayatTransaksi: didTapRiwayatTransaksiRelay.asObservable(),
            didTapPromo: didTapPromoRelay.asObservable(), 
            didTapPortfolio: didTapPortfolioRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displaySaldo.drive(onNext: {[weak self] (saldo) in
            self?.saldoLabel.text = "Rp\(saldo)"
        }).disposed(by: self.disposeBag)
    }
    
    @objc func didTapScanQRButton(_ sender: UIButton) {
        self.didTapScanQRRelay.accept(())
    }
    
    @objc func didTapTopUpButton(_ sender: UIButton) {
        self.didTapTopUpRelay.accept(())
    }
    
    @objc func didTapRiwayatTransaksiButton(_ sender: UIButton) {
        self.didTapRiwayatTransaksiRelay.accept(())
    }
    
    @objc func didTapPromoButton(_ sender: UIButton) {
        self.didTapPromoRelay.accept(())
    }
    
    @objc func didTapPortfolioButton(_ sender: UIButton) {
        self.didTapPortfolioRelay.accept(())
    }
}
