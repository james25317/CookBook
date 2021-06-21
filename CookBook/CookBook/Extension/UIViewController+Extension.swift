//
//  UIViewController+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/6/21.
//

import UIKit

extension UIViewController {

    static func saveDraftAlert(title: String?, message: String?, saveHandler: @escaping () -> Void) -> UIAlertController {

        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let saveAction = UIAlertAction(
            title: "Save",
            style: .destructive
        ) { _ in
            
            saveHandler()
        }
        
        alertController.addAction(saveAction)

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)

        return alertController
    }
}
