//
//  PasswordAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class PasswordAssembly {
    
    let authManager: AuthManagerProtocol
    let networkService: NetworkService
    
    init(authManager: AuthManagerProtocol, networkService: NetworkService) {
        self.authManager = authManager
        self.networkService = networkService
    }
    
    func assemble(completion: @escaping () -> Void) -> PasswordViewController {
        let viewController = PasswordViewController()
        let presenter = PasswordPresenter(view: viewController,
                                          authManager: authManager, 
                                          networkService: networkService,
                                          completion: completion)
        
        viewController.presenter = presenter
        return viewController
    }
    
}
