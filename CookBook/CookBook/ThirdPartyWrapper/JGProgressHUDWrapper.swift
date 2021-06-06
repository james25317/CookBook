//
//  JGProgressHUDWrapper.swift
//  CookBook
//
//  Created by James Hung on 2021/6/6.
//

import JGProgressHUD

enum HUDType {

    case success(String)

    case failure(String)
}

class CBProgressHUD {

    static let shared = CBProgressHUD()

    private init() { }

    let hud = JGProgressHUD(style: .dark)

    var view: UIView {

        // return AppDelegate.shared.window!.rootViewController!.view

        return (SceneDelegate.shared?.window?.rootViewController?.view)!
    }

    static func show(type: HUDType) {

        switch type {

        case .success(let text):

            showSuccess(text: text)

        case .failure(let text):

            showFailure(text: text)
        }
    }

    static func showText(text: String) {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showText(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = nil

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.0)
    }

    static func showSuccess(text: String = "success") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showSuccess(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.0)
    }

    static func showFailure(text: String = "Failure") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        shared.hud.show(in: shared.view)

        shared.hud.dismiss(afterDelay: 1.0)
    }

    static func show() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                show()
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = nil

        shared.hud.show(in: shared.view)
    }

    static func dismiss() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                dismiss()
            }

            return
        }

        shared.hud.dismiss()
    }
}
