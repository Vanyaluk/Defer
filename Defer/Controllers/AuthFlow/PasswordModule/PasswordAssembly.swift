//
//  PasswordAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class PasswordAssembly {
    
    let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
    
    func assemble(completion: @escaping () -> Void) -> PasswordViewController {
        let viewController = PasswordViewController()
        let presenter = PasswordPresenter(view: viewController,
                                          authManager: authManager,
                                          completion: completion)
        
        viewController.presenter = presenter
        return viewController
    }
    
}
