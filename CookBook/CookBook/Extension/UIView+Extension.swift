//
//  UIView+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/5/19.
//

import UIKit

@IBDesignable
extension UIView {

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

    @IBInspectable var borderWidth: CGFloat {

        get {

            return layer.borderWidth
        }
        set {

            layer.borderWidth = newValue
        }
    }

    @IBInspectable var cornerRadius: CGFloat {

        get {

            return layer.cornerRadius
        }
        set {

            layer.cornerRadius = newValue
        }
    }
}
