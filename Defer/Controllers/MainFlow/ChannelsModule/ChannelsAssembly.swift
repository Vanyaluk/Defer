//
//  ChannelsAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

final class ChannelsAssembly {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func assemble(completion: @escaping (Int64, String) -> Void) -> ChannelsViewController {
        let router = ChannelsRouter()
        let viewController = ChannelsViewController()
        let presenter = ChannelsPresenter(view: viewController,
                                          router: router,
                                          networkService: networkService,
                                          completion: completion)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
