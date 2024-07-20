//
//  NumberAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class NumberAssembly {
    
    private let authManager: AuthManagerProtocol
    private let networkService: NetworkService
    
    init(authManager: AuthManagerProtocol, networkService: NetworkService) {
        self.authManager = authManager
        self.networkService = networkService
    }
    
    func assemble(completion: @escaping () -> Void) -> NumberViewController {
        let viewController = NumberViewController()
        let presenter = NumberPresenter(view: viewController,
                                        authManager: authManager, 
                                        networkService: networkService,
                                        completion: completion)
        
        viewController.presenter = presenter
        return viewController
    }
    
}
