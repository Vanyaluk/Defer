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
    
    func deletingActionSheet(title: String, comletion: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) { alert in
            comletion()
        }
        let dismissAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(actionDelete)
        alert.addAction(dismissAction)
        return alert
    }
    
    func logoutAlert(title: String? = nil, message: String? = nil, comletion: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Отмена", style: .cancel)
        let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { alert in
            comletion()
        }
        alert.addAction(dismissAction)
        alert.addAction(logoutAction)
        return alert
    }
}
