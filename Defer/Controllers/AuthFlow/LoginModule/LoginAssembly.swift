//
//  LoginAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class LoginAssembly {
    
    let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
    
    func assemble(completion: @escaping () -> Void) -> LoginViewController {
        let viewController = LoginViewController()
        let presenter = LoginPresenter(view: viewController, 
                                       authManager: authManager,
                                       completion: completion)
        viewController.presenter = presenter
        return viewController
    }
    
}
