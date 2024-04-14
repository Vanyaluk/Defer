//
//  PostAssembly.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

final class PostAssembly {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func assemble(post: Components.Schemas.Post, completion: @escaping () -> ()) -> PostViewController {
        let router = PostRouter()
        let viewController = PostViewController(post: post)
        let presenter = PostPresenter(view: viewController, router: router, networkService: networkService, completion: completion)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
