//
//  HomeRouter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol HomeRouterInput {
    func pushPostModule(post: Components.Schemas.Post, completion: @escaping () -> ())
    
    func presentNewPostModule(completion: @escaping () -> Void)
}

final class HomeRouter: HomeRouterInput {
    weak var viewController: HomeViewController?
    
    let newPostAssembly: NewPostAssembly
    let postAssembly: PostAssembly
    
    init(newPostAssembly: NewPostAssembly, postAssembly: PostAssembly) {
        self.newPostAssembly = newPostAssembly
        self.postAssembly = postAssembly
    }
    
    func pushPostModule(post: Components.Schemas.Post, completion: @escaping () -> ()) {
        let vc = postAssembly.assemble(post: post, completion: completion)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentNewPostModule(completion: @escaping () -> Void) {
        let vc = UINavigationController(rootViewController: newPostAssembly.assemble(completion: completion))
        viewController?.present(vc, animated: true)
    }
}
