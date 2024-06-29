//
//  PromoDetailViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class PromoDetailViewController: UIViewController, PromoDetailView {
    var presenter: PromoDetailPresenter!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    private let requestPromoRelay = PublishRelay<Void>()
    private let didTapDetailRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestPromoRelay.accept(())
    }
    
    private func setupUI() {
        title = "Promo Detail"
        titleLabel.text = ""
        imageView.image = nil
        detailButton.addTarget(self, action: #selector(didTapDetailButton(_:)), for: .touchUpInside)
    }
    
    private func bindPresenter() {
        let input = PromoDetailPresenter.Input(
            requestPromo: requestPromoRelay.asObservable(),
            didTapDetail: didTapDetailRelay.asObservable()
            
        )
        
        let output = presenter.transform(input)
        
        output.displayPromo.drive(onNext: {[weak self] (promo) in
            self?.titleLabel.text = promo?.name
            self?.loadImage(imageUrl: promo?.images_url)
        }).disposed(by: self.disposeBag)
    }
    
    private func loadImage(imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        
        AF.request(imageUrl ,method: .get).response { response in
         switch response.result {
          case .success(let responseData):
             self.imageView.image = UIImage(data: responseData!, scale: 1)
             if (self.imageView.image == nil) {
                 self.imageView.image = UIImage(named: "img_banner")
             }
          case .failure(let error):
             print("error: ",error)
          }
        }
    }
    
    @objc func didTapDetailButton(_ sender: UIButton) {
        self.didTapDetailRelay.accept(())
    }
}
