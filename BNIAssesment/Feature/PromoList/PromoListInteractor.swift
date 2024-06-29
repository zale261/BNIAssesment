//
//  PromoListInteractor.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Alamofire
import RxSwift
import RxCocoa

protocol PromoListInteractor: BaseInteractor {
    func fetchPromos() -> Single<PromoList>
}

class PromoListInteractorImpl: PromoListInteractor {
    
    func fetchPromos() -> Single<PromoList> {
        return Single<PromoList>.create { single in
            let url = "http://demo5853970.mockable.io/promos"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjc1OTE0MTUwLCJleHAiOjE2Nzg1MDYxNTB9.TcIgL5CDZYg9o8CUsSjUbbUdsYSaLutOWni88ZBs9S8"
            ]
            
            let request = AF.request(url, headers: headers).responseDecodable(of: PromoList.self) { response in
                switch response.result {
                case .success(let promos):
                    single(.success(promos))
                case .failure(let error): 
                    single(.failure(error))
                    break
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
