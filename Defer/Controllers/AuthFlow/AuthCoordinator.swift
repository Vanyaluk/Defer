//
//  AuthCoordinator.swift
//  Defer
//
//  Created by Иван Лукъянычев on 09.04.2024.
//

import UIKit

final class AuthCoordinator: FlowCoordinator {
    
    private let authManager: AuthManagerProtocol
    private let navigationController: UINavigationController
    
    // Обновление при входе аккаунта
    private var completion: () -> Void
    
    init(authManager: AuthManagerProtocol, navigationController: UINavigationController, completion: @escaping () -> Void) {
        self.authManager = authManager
        self.navigationController = navigationController
        self.completion = completion
    }
    
    func start() {
        switch authManager.getAuthStatus() {
        case .notAuth:
            showLoginModule()
        case .authAndwaitingForTelegramNumber:
            showNumberModule()
        case .authAndWaitingForTelegramCode:
            showCodeModule()
        case .authAndWaitingForTelegramPassword:
            showPasswordModule()
        case .authAndHaveTelegram:
            completion()
        }
    }
    
    private func showLoginModule() {
        let vc = LoginAssembly(authManager: authManager).assemble(completion: start)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showNumberModule() {
        let vc = NumberAssembly(authManager: authManager).assemble(completion: start)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showCodeModule() {
        let vc = CodeAssembly(authManager: authManager).assemble(completion: start)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showPasswordModule() {
        let vc = PasswordAssembly(authManager: authManager).assemble(completion: start)
        navigationController.pushViewController(vc, animated: true)
    }
}
