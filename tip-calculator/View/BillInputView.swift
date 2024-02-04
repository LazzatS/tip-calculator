//
//  BillInputView.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 02.02.2024.
//

import UIKit
import Combine
import CombineCocoa // creats UI interface to listen to UI events

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.configure(
            topText: "Enter",
            bottomText: "your bill")
        return headerView
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.bg
        view.addCornerRadius(8.0)
        view.layer.borderWidth = 1
        view.layer.borderColor = ThemeColor.separatorColor?.cgColor
        return view
    }()
    
    private let currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(
            text: "$",
            font: ThemeFont.bold(of: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demibold(of: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.textColor
        textField.textColor = ThemeColor.textColor
        // Add toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped))
        toolBar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil),
            doneButton
        ]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        return textField
    }()
    
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    var billPublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        textField.textPublisher.sink { [unowned self] text in
            billSubject.send(text?.doubleValue ?? 0)
        }.store(in: &cancellable)
    }
    
    private func layout() {
        [headerView, textFieldContainerView].forEach { addSubview($0) }
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(textFieldContainerView.snp.centerY)
            $0.width.equalTo(68)
            $0.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDenominationLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            $0.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
}
