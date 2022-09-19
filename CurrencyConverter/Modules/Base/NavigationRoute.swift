//
//  NavigationRoute.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

/// The route protocol apply to only class
protocol Route: AnyObject {
    associatedtype T
    init(rootController: T)
}


import UIKit

class NavigationRoute: NSObject, Route {
    
    /// The refrence to controller
    private var rootController: UINavigationController?
    
    /// The initializer for Route
    typealias Controller = UINavigationController
    
    required init(rootController: Controller) {
        self.rootController = rootController
        super.init()
    }
    
    /// clean when done
    deinit {
        self.rootController = nil
    }
}

// Helpers for routing
extension NavigationRoute {
    
    /// Sets the controller as the root of rootController if the rootcontroller is navigation controller
    ///
    /// - Parameters:
    ///   - presentable: the controller to be set as root view controller
    ///   - animated: is the transition animated
    ///   - hideBar: will the navigation bar be hidden
    func setRoot(_ presentable: Presentable?, animated: Bool = false, hideBar: Bool = true) {
        
        guard let navigationController = rootController,
            let controller = presentable?.presenting else {
                assertionFailure("Please properly check that controller and navigation controller both are provided")
                return
        }
        navigationController.isNavigationBarHidden = hideBar
        if hideBar {
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.navigationItem.largeTitleDisplayMode = .never
        }
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    /// Present a controller on the routes root controller
    /// - Parameter presentable: the presenting controller
    func present(_ presentable: Presentable?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navigationController = rootController,
            let controller = presentable?.presenting else {
                assertionFailure("Please properly check that controller and navigation controller both are provided")
                return
        }
        controller.presentationController?.delegate = controller
        navigationController.present(controller, animated: animated, completion: completion)
    }
    
    
    /// Dismiss the presented route
    /// - Parameter animated: the transition should be animated or not
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let navigationController = rootController else {
            assertionFailure("Please properly check that controller and navigation controller both are provided")
            return
        }
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    /// Push the controller on navigation stack if the root of the route is navigation controller
    ///
    /// - Parameters:
    ///   - presentable: the controller to push
    ///   - animated: animated or not
    func push(_ presentable: Presentable?, animated: Bool = true) {
        guard let navigationController = rootController,
            let controller = presentable?.presenting else {
                assertionFailure("Please properly check that controller and navigation controller both are provided")
                return
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    /// The method to pop the controller from navigation stack, if the root of route is navigation controller
    ///
    /// - Parameter animated: animated or not
    func pop(toRoot: Bool = false, animated: Bool = true) {
        guard let navigationController = rootController else {
            assertionFailure("Please properly check that navigation controller is present as the root of router")
            return
        }
        if toRoot {
            navigationController.popToRootViewController(animated: animated)
        } else {
            navigationController.popViewController(animated: animated)
        }
    }
}
