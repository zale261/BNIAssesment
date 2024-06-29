//
//  BasePresenter.swift
//  BNIAssesment
//
//  Created by MacBook on 27/06/2024.
//

import Foundation

protocol BasePresenter {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
