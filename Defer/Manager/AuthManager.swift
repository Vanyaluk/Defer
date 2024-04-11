//
//  AuthManager.swift
//  Defer
//
//  Created by Иван Лукъянычев on 09.04.2024.
//

import UIKit

public enum AuthStatus {
    case notAuth  // нет аккаунта
    case authAndwaitingForTelegramNumber  // есть аккаунт, но нет тг
    case authAndWaitingForTelegramCode  // ожидается ввод кода
    case authAndWaitingForTelegramPassword  // ожидается ввод пароля
    case authAndHaveTelegram  // подвязан тг, и есть вход в аккаунт
}

// MARK: - Вход в систему
protocol AuthManagerProtocol {
    /// Получить статус входа
    func getAuthStatus() -> AuthStatus
    
    /// Задать новое значение для статуса входа
    func setAuthStatus(_ newValue: AuthStatus)
}

// MARK: - Менеджер входа в приложение
final class AuthManager: AuthManagerProtocol {
    
    private var authStatus: AuthStatus = .notAuth
    
    init() {
        updateAuthStatusFromKeychain()
    }
    
    private func updateAuthStatusFromKeychain() {
        if let _ = KeychainManager.shared.getKey() {
            authStatus = .authAndHaveTelegram
        } else {
            authStatus = .notAuth
        }
    }
    
    func setAuthStatus(_ newValue: AuthStatus) {
        authStatus = newValue
    }
    
    func getAuthStatus() -> AuthStatus {
        return authStatus
    }
}
