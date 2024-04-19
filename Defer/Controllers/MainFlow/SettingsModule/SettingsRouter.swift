//
//  SettingsRouter.swift
//  Super easy dev
//
//  Created by vanyaluk on 10.04.2024
//

import UIKit

protocol SettingsRouterInput {
    func presentAlert(alert: UIAlertController)
}

final class SettingsRouter: SettingsRouterInput {
    weak var viewController: SettingsViewController?
    
    func presentAlert(alert: UIAlertController) {
        viewController?.present(alert, animated: true)
    }
}
