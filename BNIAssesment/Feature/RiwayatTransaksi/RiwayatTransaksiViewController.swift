//
//  RiwayatTransaksiViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class RiwayatTransaksiViewController: UIViewController, RiwayatTransaksiView {
    var presenter: RiwayatTransaksiPresenter!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let requestHistoryRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private var history: [Transaksi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestHistoryRelay.accept(())
    }
    
    private func setupUI() {
        title = "Riwayat Transaksi"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
    }
    
    private func bindPresenter() {
        let input = RiwayatTransaksiPresenter.Input(
            requestHistory: self.requestHistoryRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displayHistory.drive(onNext: {[weak self] (history) in
            self?.history = history
            self?.tableView.reloadData()
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
}

extension RiwayatTransaksiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let data = history[indexPath.row]
        cell.textLabel?.text = "\(data.merchant) - Rp\(data.nominal)"
        return cell
    }
}
