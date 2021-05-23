//
//  Box.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//
/*  From raywenderlich: https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc#toc-anchor-008
 */
// 被加到 Box 的對象會跟 listener 綁定，一但 Box.value 值變動，listener 獲取新的值，所有正在綁定(監聽)的對象都會接到最新的值。

import Foundation

final class Box<T> {

    // 1 Each Box can have a Listener that Box notifies when the value changes.
    typealias Listener = (T) -> Void

    var listeners: [Listener?] = []

    // 2 Box has a generic type value. The didSet property observer detects any changes and notifies Listener of any value update.
    var value: T {
        
        didSet {

            listeners.forEach { listener in
                listener?(value)
            }
        }
    }

    // 3 The initializer sets Box‘s initial value.
    init(_ value: T) {

        self.value = value
    }

    // 4 When a Listener calls bind(listener:) on Box, it becomes Listener and immediately gets notified of the Box‘s current value.
    func bind(listener: Listener?) {

        listeners.append(listener)

        listeners.forEach { listener in

            listener?(value)
        }
    }

    func unbind(listener: Listener?) {

        self.listeners = self.listeners.filter {

            $0 as AnyObject !== listener as AnyObject
        }

    }
}
