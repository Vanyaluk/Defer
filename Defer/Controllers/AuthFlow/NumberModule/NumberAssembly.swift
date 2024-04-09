//
//  NumberAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class NumberAssembly {
    
    let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
    
    func assemble(completion: @escaping () -> Void) -> NumberViewController {
        let viewController = NumberViewController()
        let presenter = NumberPresenter(view: viewController,
                                        authManager: authManager,
                                        completion: completion)
        
        viewController.presenter = presenter
        return viewController
    }
    
}
