//
//  NetworkMonitor.swift
//  CookBook
//
//  Created by James Hung on 2021/6/20.
//

import Foundation
import Network

class NetworkMonitor {

    static let shared = NetworkMonitor()

    var isReachable: Bool { status == .satisfied }

    private let monitor = NWPathMonitor()

    private var status = NWPath.Status.requiresConnection

    private init() {

        startMonitoring()
    }

    func startMonitoring() {

        monitor.pathUpdateHandler = { [weak self] path in

            self?.status = path.status
        }

        let queue = DispatchQueue(label: "NetworkMonitor")

        monitor.start(queue: queue)
    }

    func stopMonitoring() {

        monitor.cancel()
    }
}
