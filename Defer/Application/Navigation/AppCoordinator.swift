//
//  AppCoordinator.swift
//  Defer
//
//  Created by Иван Лукъянычев on 09.04.2024.
//

import UIKit

final class AppCoordinator: FlowCoordinator {
    
    private weak var window: UIWindow?
    private let authManager: AuthManagerProtocol
    
    init(window: UIWindow?, authManager: AuthManagerProtocol) {
        self.window = window
        self.authManager = authManager
    }
    
    func start() {
        // transitionCrossDissolve
        if let window {
            UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        switch authManager.getAuthStatus() {
        case .authAndHaveTelegram:
            startMainFlow()
        default:
            startAuthFlow()
        }
    }
    
    private func startMainFlow() {
        let vc = HomeAssembly().assemble()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    private func startAuthFlow() {
        let vc = UINavigationController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        let authCoordinator = AuthCoordinator(authManager: authManager, navigationController: vc) {
            self.start()
        }
        authCoordinator.start()
    }
}
