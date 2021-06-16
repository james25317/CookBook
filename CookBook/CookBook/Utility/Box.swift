//
//  Box.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation

final class Box<T> {

    typealias Listener = (T) -> Void

    var listeners: [Listener?] = []

    var value: T {

        didSet {

            listeners.forEach { listener in

                listener?(value)
            }
        }
    }

    init(_ value: T) {

        self.value = value
    }

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
