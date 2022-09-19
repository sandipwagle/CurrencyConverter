//
//  BaseCoordinator.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

/// The protocol for coordinator
protocol Coordinator: AnyObject {
    func start()
}


// The base coordinator
class BaseCoordinator: Coordinator {
    
    // Private property to hold refrence to child coordinators
    private(set) var childCoordinators: [Coordinator] = []
    
    // When a coordinator is removed
    private var onRemove: (() -> Void)?
    
    // When a coordinator is finished
    var onFinish: (() -> Void)?
    
    // Public initializer
    init() {}
    
    /// Method to start the coordinator
    func start() {}
    
    /// This method will add the child coordinator that are currently coordinating
    ///
    /// - Parameter coordinator: the coordinator
    private func addChild(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator}) else { return } //child coordinator is already coordinating check
        childCoordinators.append(coordinator)
    }
    
    /// Method to remove child coordinator. This method will remove all the child coordinators of the provided coordinator as well
    ///
    /// - Parameter coordinator: the coordinator to remove
    private func removeChild(_ coordinator: Coordinator?) {
        guard !childCoordinators.isEmpty, let coordinator = coordinator as? BaseCoordinator else { return }
        // Remove all childs of coordinator
        if !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeChild($0) })
        }
        
        // Remove the coordinator itself
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    /// This method will add new coordinator and start it
    ///
    /// - Parameter coordinator: the coordinator to start
    @discardableResult
    func coordinate<T: BaseCoordinator>(_ type: T.Type = T.self, to coordinator: T) -> BaseCoordinator {
        addChild(coordinator)
        coordinator.onRemove = { [unowned self, unowned coordinator] in
            self.removeChild(coordinator)
        }
        coordinator.start()
        return coordinator
    }
    
    /// Method to complete the opertaion of a coordinator
    func finish() {
        onRemove?()
        onFinish?()
    }
    
    /// returns child coordinator of type C if it exists. else return nil
    /// - Parameter type: class of type Coordinator
    private func getChild<C>(type: C.Type) -> C? {
        for coordinator in childCoordinators {
            if let requiredCoordinator = coordinator as? C {
                return requiredCoordinator
            }
        }
        return nil
    }
    
    deinit {
        debugPrint("De-Initialized Coordinator --> \(String(describing: self))")
    }
}

