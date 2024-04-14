//
//  NewPostRouter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol NewPostRouterInput {
    func dismissView()
    
    func pushChanelsModule(completion: @escaping (Int64, String) -> Void)
}

final class NewPostRouter: NewPostRouterInput {
    weak var viewController: NewPostViewController?
    
    let channelsAssebmly: ChannelsAssembly
    
    init(channelsAssebmly: ChannelsAssembly) {
        self.channelsAssebmly = channelsAssebmly
    }
    
    func dismissView() {
        viewController?.dismiss(animated: true)
    }
    
    func pushChanelsModule(completion: @escaping (Int64, String) -> Void) {
        let vc = channelsAssebmly.assemble(completion: completion)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
