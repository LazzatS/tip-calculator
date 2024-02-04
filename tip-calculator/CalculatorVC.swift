//
//  CalculatorVC.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 01.02.2024.
//

import UIKit
import SnapKit
import Combine

class CalculatorVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        logoView,
        resultView,
        billInputView,
        tipInputView,
        splitInputView,
        UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor.bg
        layout()
        bind()
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.billPublisher,
            tipPublisher: Just(.tenPercent).eraseToAnyPublisher(),
            splitPublisher: Just(5).eraseToAnyPublisher())
        
        let output = vm.transform(input: input)
    }
    
    private func layout() {
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.snp.topMargin).inset(16)
            $0.bottom.equalTo(view.snp.bottomMargin).inset(16)
        }
        
        logoView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints {
            $0.height.equalTo(56+56+16)
        }
        
        splitInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
}

