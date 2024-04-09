//
//  HomeAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

final class HomeAssembly {
    
    func assemble() -> HomeViewController {
        let router = HomeRouter()
        let viewController = HomeViewController()
        let presenter = HomePresenter(view: viewController, router: router)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
