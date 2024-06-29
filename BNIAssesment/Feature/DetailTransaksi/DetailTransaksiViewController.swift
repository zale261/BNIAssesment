//
//  DetailTransaksiViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class DetailTransaksiViewController: UIViewController, DetailTransaksiView {
    var presenter: DetailTransaksiPresenter!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let requestHistoryRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private var transactions: [DonutChart.DetailTransaksi.TransactionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestHistoryRelay.accept(())
    }
    
    private func setupUI() {
        title = "Detail Transaksi"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
    }
    
    private func bindPresenter() {
        let input = DetailTransaksiPresenter.Input(
            requestHistory: self.requestHistoryRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displayHistory.drive(onNext: {[weak self] (transactions) in
            self?.transactions = transactions
            self?.tableView.reloadData()
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
}

extension DetailTransaksiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let data = transactions[indexPath.row]
        cell.textLabel?.text = "\(data.trx_date) - Rp\(data.nominal)"
        return cell
    }
}
