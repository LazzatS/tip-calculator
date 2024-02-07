//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 02.02.2024.
//

import UIKit
import Combine

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.configure(
            topText: "Choose",
            bottomText: "your tip")
        return headerView
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }
        .assign(to: \.value, on: tipSubject)
        .store(in: &cancellables)
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(of: 20)
        button.setTitleColor(ThemeColor.textColor, for: .normal)
        button.backgroundColor = ThemeColor.primaryColor
        button.tintColor = ThemeColor.textColor
        button.addCornerRadius(8.0)
        
        button.tapPublisher.sink { [weak self] _ in
            self?.didTapCustomButton()
        }.store(in: &cancellables)
        
        return button
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    var tipPublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        tipSubject.send(.none)
    }
    
    private func layout() {
        [headerView, buttonVStackView].forEach {
            addSubview($0)
        }
        
        buttonVStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            $0.width.equalTo(68)
            $0.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
    private func didTapCustomButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Make it generous!"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel", 
                style: .cancel)
            let okAction = UIAlertAction(
                title: "Ok",
                style: .default) { [weak self] _ in
                    guard let text = controller.textFields?.first?.text,
                          let value = Int(text) else { return }
                    self?.tipSubject.send(.custom(value: value))
                }
            [okAction, cancelAction].forEach { controller.addAction($0) }
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
    private func observe() {
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none:
                break
            case .tenPercent:
                tenPercentTipButton.backgroundColor = ThemeColor.secondaryColor
            case .fifteenPercent:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondaryColor
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondaryColor
            case .custom(let value):
                customTipButton.backgroundColor = ThemeColor.secondaryColor
                let text = NSMutableAttributedString(
                    string: String().currencySymbol + "\(value)",
                    attributes: [
                        .font: ThemeFont.bold(of: 20)
                    ])
                text.addAttributes([
                    .font: ThemeFont.bold(of: 14)
                ], range: NSMakeRange(0, 1))
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    private func resetView() {
        [tenPercentTipButton,
         fifteenPercentTipButton,
         twentyPercentTipButton,
         customTipButton].forEach {
            $0.backgroundColor = ThemeColor.primaryColor
        }
        
        let text = NSMutableAttributedString(
            string: "Custom Tip",
            attributes: [.font: ThemeFont.bold(of: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primaryColor
        button.tintColor = ThemeColor.textColor
        button.addCornerRadius(8.0)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(of: 20)
            ])
        text.addAttributes([
            .font: ThemeFont.demibold(of: 14)
        ], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}
