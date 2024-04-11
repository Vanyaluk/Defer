//
//  SettingsAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 10.04.2024
//

import UIKit

final class SettingsAssembly {
    
    let networkService: NetworkService
    let authManager: AuthManagerProtocol
    
    init(networkService: NetworkService, authManager: AuthManagerProtocol) {
        self.networkService = networkService
        self.authManager = authManager
    }
    
    func assemble(completion: @escaping () -> Void) -> SettingsViewController {
        let router = SettingsRouter()
        let viewController = SettingsViewController()
        let presenter = SettingsPresenter(view: viewController, router: router, networkService: networkService, authManager: authManager, completion: completion)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
