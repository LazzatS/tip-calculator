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
    
    private lazy var viewTapGesture: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapGesture: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor.bg
        layout()
        bind()
        observe()
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.billPublisher,
            tipPublisher: tipInputView.tipPublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapGesture)
        
        let output = vm.transform(input: input)
        output.updatePublisher.sink { [unowned self] result in
            resultView.configure(result: result)
            print(result)
        }.store(in: &cancellables)
        
        output.resetCalculatorPublisher.sink { _ in
            print("need to reset calculator")
        }.store(in: &cancellables)
    }
    
    private func observe() {
        viewTapGesture.sink { [unowned self] _ in
            view.endEditing(true)
        }.store(in: &cancellables)
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

