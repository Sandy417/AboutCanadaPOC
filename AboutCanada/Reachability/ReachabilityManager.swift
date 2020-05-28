//
//  ReachabilityManager.swift
//  AboutCanada
//
//  Created by Sandeep on 20/05/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityCheckManager: NSObject {

    var reachability: Reachability!

    // Create a singleton instance
    static let sharedInstance: ReachabilityCheckManager = { return ReachabilityCheckManager() }()

    override init() {
        super.init()
        do {
            try reachability = Reachability()
        } catch {
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            try reachability.startNotifier()
        } catch {
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
    }

    static func stopNotifier() {
        do {
            try (ReachabilityCheckManager.sharedInstance.reachability).startNotifier()
        } catch {
        }
    }

    // Network is reachable
    static func isReachable(completed: @escaping (ReachabilityCheckManager) -> Void) {
        if (ReachabilityCheckManager.sharedInstance.reachability).connection != .unavailable {
            completed(ReachabilityCheckManager.sharedInstance)
        }
    }

    // Network is unreachable
    static func isUnreachable(completed: @escaping (ReachabilityCheckManager) -> Void) {
        if (ReachabilityCheckManager.sharedInstance.reachability).connection == .unavailable {
            completed(ReachabilityCheckManager.sharedInstance)
        }
    }

    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (ReachabilityCheckManager) -> Void) {
        if (ReachabilityCheckManager.sharedInstance.reachability).connection == .cellular {
            completed(ReachabilityCheckManager.sharedInstance)
        }
    }

    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (ReachabilityCheckManager) -> Void) {
        if (ReachabilityCheckManager.sharedInstance.reachability).connection == .wifi {
            completed(ReachabilityCheckManager.sharedInstance)
        }
    }
}
