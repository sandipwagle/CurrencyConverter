//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var appcoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        startApplication()
    }
    
    private func startApplication() {
        
        Database.default.initalizaDB()
        NetworkStatusProvider.shared.start()
        
        let baseNavigationController = BaseNavigationController(appearance: UINavigationBarAppearance.getAppNavigationBarAppearance())
        
        let route = NavigationRoute(rootController: baseNavigationController)
        
        appcoordinator = AppCoordinator(route: route)
        appcoordinator?.start()
        
        window?.rootViewController = baseNavigationController
        window?.makeKeyAndVisible()

    }


}

