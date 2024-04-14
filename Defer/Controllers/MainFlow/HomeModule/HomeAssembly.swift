//
//  HomeAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class HomeAssembly {
    
    let networkService: NetworkService
    let authManager: AuthManagerProtocol
    
    init(networkService: NetworkService, authManager: AuthManagerProtocol) {
        self.networkService = networkService
        self.authManager = authManager
    }
    
    func assemble() -> HomeViewController {
        let router = HomeRouter(newPostAssembly: NewPostAssembly(networkService: networkService),
                                postAssembly: PostAssembly(networkService: networkService))
        let viewController = HomeViewController()
        let presenter = HomePresenter(view: viewController, router: router, networkService: networkService, authManager: authManager)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
