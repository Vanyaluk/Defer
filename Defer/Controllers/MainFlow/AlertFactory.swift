//
//  AlertFactory.swift
//  Defer
//
//  Created by Иван Лукъянычев on 14.04.2024.
//

import UIKit

class AlertFactory {
    func warningAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .default)
        alert.addAction(action)
        return alert
    }
}
