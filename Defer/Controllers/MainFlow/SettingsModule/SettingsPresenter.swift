//
//  SettingsPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 10.04.2024
//

import UIKit

protocol SettingsPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func logoutAccount()
    
    func logoutTelegramSession()
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
    func viewDidLoaded() {
        // first setup view
    }
    
    func logoutAccount() {
        KeychainManager.shared.clearKey()
        authManager.setAuthStatus(.notAuth)
        completion()
    }
    
    func logoutTelegramSession() {
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
