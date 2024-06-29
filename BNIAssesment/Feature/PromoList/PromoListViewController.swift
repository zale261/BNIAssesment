//
//  PromoListViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class PromoListViewController: UIViewController, PromoListView {    
    var presenter: PromoListPresenter!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let requestPromosRelay = PublishRelay<Void>()
    private let didSelectPromoRelay = PublishRelay<Promo>()
    private let disposeBag = DisposeBag()
    
    private var promos: [Promo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestPromosRelay.accept(())
    }
    
    private func setupUI() {
        title = "Promo List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PromoCell")
    }
    
    private func bindPresenter() {
        let input = PromoListPresenter.Input(
            requestPromos: requestPromosRelay.asObservable(),
            didSelectPromo: didSelectPromoRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displayPromos.drive(onNext: {[weak self] (promos) in
            self?.promos = promos
            self?.tableView.reloadData()
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        output.displayError.drive(onNext: {[weak self] (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: self.disposeBag)
    }
}

extension PromoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCell", for: indexPath)
        let promo = promos[indexPath.row]
        cell.textLabel?.text = promo.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let promo = self.promos[indexPath.row]
        self.didSelectPromoRelay.accept(promo)
    }
}
