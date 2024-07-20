//
//  NumberPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol NumberPresenterProtocol: AnyObject {
    
    func buttonTapped(number: String)
    
    func logoutAccount()
}

final class NumberPresenter {
    weak var view: NumberViewProtocol?
    
    let authManager: AuthManagerProtocol
    let networkService: NetworkService
    var completion: () -> Void

    init(view: NumberViewProtocol, authManager: AuthManagerProtocol, networkService: NetworkService, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.networkService = networkService
        self.completion = completion
    }
}

extension NumberPresenter: NumberPresenterProtocol {
    
    func buttonTapped(number: String) {
        // TODO: запрос за статусом на сервер
        view?.loadingStart()
        
        if isValid(text: number) {
            sentNumberToTelegram(number: number)
        } else {
            view?.loadingFinish(warning: "Введите номер целиком")
        }
    }
    
    private func isValid(text: String) -> Bool {
        return text.count == 18
    }
    
    private func sentNumberToTelegram(number: String) {
        Task(priority: .medium) {
            do {
                let result = try await networkService.numberTelegram(number: number)
                if let result {
                    DispatchQueue.main.async {
                        self.resultParsing(result: result)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.loadingFinish(warning: "Такого номера не существует.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.loadingFinish(warning: "Приложение глюкнулось.")
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
    
    func logoutAccount() {
        KeychainManager.shared.clearKey()
        authManager.setAuthStatus(.notAuth)
        completion()
    }
}

// MARK: - Private

private extension NumberPresenter {
    
}
