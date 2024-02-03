//
//  ResultView.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 02.02.2024.
//

import UIKit

class ResultView: UIView {
    
    private let headerLabel: UILabel = {
        LabelFactory.build(
            text: "Total p/person",
            font: ThemeFont.demibold(of: 18))
    }()
    
    private let amountPerPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [
                .font: ThemeFont.bold(of: 48)
            ])
        text.addAttributes([
            .font: ThemeFont.bold(of: 24)
        ], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private let hLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separatorColor
        return view
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        AmountView(),
        UIView(),
        AmountView()
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            amountPerPersonLabel,
            hLineView,
            hStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = ThemeColor.bg
        layer.borderWidth = 1
        layer.borderColor = ThemeColor.separatorColor?.cgColor
        layer.cornerRadius = 12
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        hLineView.snp.makeConstraints {
            $0.height.equalTo(2)
        }
    }
}

class AmountView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {}
}
