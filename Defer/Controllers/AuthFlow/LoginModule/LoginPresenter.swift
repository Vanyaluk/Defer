//
//  LoginPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func loginUser(login: String, password: String)
}

final class LoginPresenter {
    
    weak var view: LoginViewProtocol?
    
    let authManager: AuthManagerProtocol
    let networkService: NetworkService
    var completion: () -> Void

    init(view: LoginViewProtocol, authManager: AuthManagerProtocol, networkService: NetworkService, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.networkService = networkService
        self.completion = completion
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func loginUser(login: String, password: String) {
        view?.loadingStart()
        
        if let temp = isValid(login: login, password: password) {
            view?.loadingFinish(warning: temp)
            return
        }
        
        Task(priority: .medium) {
            do {
                let token = try await networkService.registration(login: login, password: password)
                if let token {
                    checkTelegramIsLinked(with: token)
                } else {
                    DispatchQueue.main.async {
                        self.view?.loadingFinish(warning: "Такой аккаунт существует. Неверный пароль")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.loadingFinish(warning: "Ошибка")
                }
            }
        }
    }
    
    private func isValid(login: String, password: String) -> String? {
        if login.count < 5 { return "Логин должен быть 5 и больше символов" }
        if password.count < 6 { return "Пароль должен быть 6 и больше символов" }
        return nil
    }
    
    private func checkTelegramIsLinked(with token: String) {
        Task(priority: .medium) {
            do {
                let result = try await networkService.checkTelegramLinked(token: token)
                if let result {
                    DispatchQueue.main.async {
                        self.resultParsing(result: result)
                    }
                } else {
                    DispatchQueue.main.async { 
                        self.view?.loadingFinish(warning: "Неверный запрос в Telegram")
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

//
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    self.view?.loadingFinish(warning: nil)
//    self.authManager.changeAuthStatus(.authAndwaitingForTelegramNumber)
//    self.completion()
//}


