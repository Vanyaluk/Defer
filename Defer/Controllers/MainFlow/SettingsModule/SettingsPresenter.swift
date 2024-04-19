//
//  SettingsPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 10.04.2024
//

import UIKit

protocol SettingsPresenterProtocol: AnyObject {
    func logoutAccountAlert()
    
    func logoutTelegramSessionAlert()
}

final class SettingsPresenter {
    weak var view: SettingsViewProtocol?
    var router: SettingsRouterInput
    
    let networkService: NetworkService
    let authManager: AuthManagerProtocol
    private let completion: () -> Void

    init(view: SettingsViewProtocol, router: SettingsRouterInput, networkService: NetworkService, authManager: AuthManagerProtocol, completion: @escaping () -> Void) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.authManager = authManager
        self.completion = completion
    }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    func logoutAccountAlert() {
        let alert = AlertFactory().logoutAlert(title: "Выйти из аккаунта?", message: "Убедитесь, что вы помните логин и пароль от аккаунта.") { [weak self] in
            self?.logoutAccount()
        }
        router.presentAlert(alert: alert)
    }
    
    func logoutTelegramSessionAlert() {
        let alert = AlertFactory().logoutAlert(title: "Завершить Telegram?") { [weak self] in
            self?.logoutTelegramSession()
        }
        router.presentAlert(alert: alert)
    }
    
    private func logoutAccount() {
        KeychainManager.shared.clearKey()
        authManager.setAuthStatus(.notAuth)
        completion()
    }
    
    private func logoutTelegramSession() {
        Task(priority: .medium) {
            do {
                let result = try await networkService.logOutTelegram()
                if result {
                    DispatchQueue.main.async { [weak self] in
                        self?.authManager.setAuthStatus(.authAndwaitingForTelegramNumber)
                        self?.completion()
                    }
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    print("Ошибка")
                }
            }
        }
    }
}
