//
//  CodePresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol CodePresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func sendCode(_ code: String)
}

final class CodePresenter {
    weak var view: CodeViewProtocol?
    
    let authManager: AuthManagerProtocol
    let networkService: NetworkService
    var completion: () -> Void

    init(view: CodeViewProtocol, authManager: AuthManagerProtocol, networkService: NetworkService, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.networkService = networkService
        self.completion = completion
    }
}

extension CodePresenter: CodePresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func sendCode(_ code: String) {
        // TODO: запрос за статусом на сервер
        view?.loadingStart()
        
        if isValid(text: code) {
            sendCodeToTelegram(code: code)
        } else {
            view?.loadingFinish(warning: "Неверный формат номера")
        }
    }
    
    private func isValid(text: String) -> Bool {
        return true
    }
    
    private func sendCodeToTelegram(code: String) {
        Task(priority: .medium) {
            do {
                let result = try await networkService.codeTelegram(code: code)
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
