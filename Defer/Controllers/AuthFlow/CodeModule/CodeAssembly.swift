//
//  CodeAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class CodeAssembly {
    
    let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
    
    func assemble(completion: @escaping () -> Void) -> CodeViewController {
        let viewController = CodeViewController()
        let presenter = CodePresenter(view: viewController,
                                      authManager: authManager,
                                      completion: completion)
        
        viewController.presenter = presenter
        return viewController
    }
    
}
