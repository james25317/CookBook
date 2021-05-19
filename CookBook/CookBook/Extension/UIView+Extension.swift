//
//  UIView+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/5/19.
//

import UIKit

@IBDesignable
extension UIView {

    // Border Color
    @IBInspectable var borderColor: UIColor? {

        get {

            guard let borderColor = layer.borderColor else {

                return nil
            }

            return UIColor(cgColor: borderColor)
        }
        set {

            layer.borderColor = newValue?.cgColor
        }
    }

    // Border width
    @IBInspectable var borderWidth: CGFloat {

        get {

            return layer.borderWidth
        }
        set {

            layer.borderWidth = newValue
        }
    }

    // Corner radius
    @IBInspectable var cornerRadius: CGFloat {

        get {

            return layer.cornerRadius
        }
        set {

            layer.cornerRadius = newValue
        }
    }
}
