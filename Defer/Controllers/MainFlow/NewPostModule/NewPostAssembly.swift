//
//  NewPostAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

final class NewPostAssembly {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func assemble(completion: @escaping () -> Void) -> NewPostViewController {
        let router = NewPostRouter(channelsAssebmly: ChannelsAssembly(networkService: networkService))
        let viewController = NewPostViewController()
        let presenter = NewPostPresenter(view: viewController, router: router, networkService: networkService, completion: completion)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
