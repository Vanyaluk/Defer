//
//  PostRouter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol PostRouterInput {
    func dismissView()
}

final class PostRouter: PostRouterInput {
    weak var viewController: PostViewController?
    
    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
