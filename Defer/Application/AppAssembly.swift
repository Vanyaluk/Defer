//
//  AppAssembly.swift
//  Defer
//
//  Created by Иван Лукъянычев on 09.04.2024.
//

import UIKit

final class AppAssembly {
    
    static func assemble(window: UIWindow?) -> FlowCoordinator {
        let authManager = AuthManager()
        
        let appCoordinator = AppCoordinator(window: window, authManager: authManager)
        return appCoordinator
    }
}
