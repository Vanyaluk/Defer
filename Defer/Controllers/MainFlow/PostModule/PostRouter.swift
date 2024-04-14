//
//  PostRouter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol PostRouterInput {
    func dismissView()
    
    func presentSheet(completion: @escaping () -> ())
}

final class PostRouter: PostRouterInput {
    weak var viewController: PostViewController?
    
    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func presentSheet(completion: @escaping () -> ()) {
        let alert = AlertFactory().deletingActionSheet(title: "Удалить пост?", comletion: completion)
        viewController?.present(alert, animated: true)
    }
}
