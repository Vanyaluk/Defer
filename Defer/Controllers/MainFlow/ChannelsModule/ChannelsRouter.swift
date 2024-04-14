//
//  ChannelsRouter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol ChannelsRouterInput {
    func dismiss()
}

final class ChannelsRouter: ChannelsRouterInput {
    weak var viewController: ChannelsViewController?
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
