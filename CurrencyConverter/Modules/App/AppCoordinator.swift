//
//  SceneDelegate.swift
//  AppCoordinator
//
//  Created by rabin on 19/07/2022.
//

import Combine
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private let route: NavigationRoute
    
    private var bag = Set<AnyCancellable>()
    
    init(route: NavigationRoute) {
        self.route = route
    }
    
    override func start() {
        startAppFlow()
    }
    
    private func startAppFlow() {
        runHomeCoordinator()
    }
    
    private func runHomeCoordinator() {
        
        let coordinator = HomeCoordinator(route: route)
        
        coordinator.onFinish = {[unowned self] in
            self.start()
        }
        coordinate(to: coordinator)
    }
    
}

