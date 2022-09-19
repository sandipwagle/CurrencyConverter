//
//  NetworkStatusProvider.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Network
import Combine

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetworkStatusProvider {
    static let shared = NetworkStatusProvider()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var isOn: Bool = false

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func start() {
        self.monitor.pathUpdateHandler = { path in
            self.isOn = path.status == .satisfied
        }
    }

    func stop() {
        self.monitor.cancel()
    }
}
