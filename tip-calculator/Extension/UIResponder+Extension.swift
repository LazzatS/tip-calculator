//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 04.02.2024.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
