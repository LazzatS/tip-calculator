//
//  UIView+Extension.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 03.02.2024.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
