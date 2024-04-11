//
//  PasswordPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol PasswordPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func sendPassword(_ password: String)
}

final class PasswordPresenter {
    weak var view: PasswordViewProtocol?
    
    let authManager: AuthManagerProtocol
    let networkService: NetworkService
    var completion: () -> Void

    init(view: PasswordViewProtocol, authManager: AuthManagerProtocol, networkService: NetworkService, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.networkService = networkService
        self.completion = completion
    }
}

extension PasswordPresenter: PasswordPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func sendPassword(_ password: String) {
        // TODO: запрос за статусом на сервер
        view?.loadingStart()
        
        if isValid(text: password) {
            sendPasswordToTelegram(password: password)
        } else {
            view?.loadingFinish(warning: "Неверный формат номера")
        }
    }
    
    private func isValid(text: String) -> Bool {
        return true
    }
    
    private func sendPasswordToTelegram(password: String) {
        Task(priority: .medium) {
            do {
                let result = try await networkService.twoFactorPassword(password: password)
                if let result {
                    DispatchQueue.main.async {
                        self.resultParsing(result: result)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.loadingFinish(warning: "Неверный пароль.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.loadingFinish(warning: "Ошибка при запросе в Telegram")
                }
            }
        }
    }
    
    private func resultParsing(result: String) {
        self.view?.loadingFinish(warning: nil)
        if result == "WaitingForPhoneNumber" {
            authManager.setAuthStatus(.authAndwaitingForTelegramNumber)
            completion()
        } else if result == "WaitingForCode" {
            authManager.setAuthStatus(.authAndWaitingForTelegramCode)
            completion()
        } else if result == "WaitingForPassword" {
            authManager.setAuthStatus(.authAndWaitingForTelegramPassword)
            completion()
        } else if result == "Ready" {
            authManager.setAuthStatus(.authAndHaveTelegram)
            completion()
        } else {
            view?.loadingFinish(warning: "Странный результат при запросе в Telegram")
        }
    }
}
