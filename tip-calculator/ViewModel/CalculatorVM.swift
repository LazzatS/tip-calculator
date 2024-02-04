//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 04.02.2024.
//

import Foundation
import Combine

class CalculatorVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updatePublisher: AnyPublisher<Result, Never>
    }
    
    func transform(input: Input) -> Output {
        let result = Result(amountPerPerson: 500, totalBill: 1000, totalTip: 50.5)
        return Output(updatePublisher: Just(result).eraseToAnyPublisher())
    }
}
