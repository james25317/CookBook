//
//  UIViewController+Extension.swift
//  CookBook
//
//  Created by James Hung on 2021/6/21.
//

import UIKit

extension UIViewController {

    enum ViewController: String {

        case today = "Today"

        case editName = "EditName"

        case editDone = "EditDone"

        case profile = "Profile"

        case read = "Read"
    }

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

    static func uploadImageActionSheet(title: String?, message: String?, cameraHandler: @escaping () -> Void, albumHandler: @escaping () -> Void) -> UIAlertController {

        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )

        let cameraAction = UIAlertAction(
            title: "Camera",
            style: .default
        ) { _ in

            cameraHandler()
        }

        controller.addAction(cameraAction)

        let albumAction = UIAlertAction(
            title: "Album",
            style: .default
        ) { _ in

            albumHandler()
        }

        controller.addAction(albumAction)

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )

        controller.addAction(cancelAction)

        return controller
    }

    func instantiate(for viewController: ViewController) -> UIViewController {

        switch viewController {

        case .editName:
            break
        case .profile:
            break
        case .read:
            break
        case .today:
            break
        case .editDone:
            break
        }

        return UIViewController()
    }
}
