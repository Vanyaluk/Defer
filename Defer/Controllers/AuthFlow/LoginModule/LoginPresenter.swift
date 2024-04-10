//
//  LoginPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func buttonTapped()
}

final class LoginPresenter {
    
    weak var view: LoginViewProtocol?
    
    let authManager: AuthManagerProtocol
    var completion: () -> Void

    init(view: LoginViewProtocol?, authManager: AuthManagerProtocol, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.completion = completion
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func buttonTapped() {
        // TODO: запрос за статусом на сервер
        view?.loadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view?.loadingFinish(warning: nil)
            self.authManager.changeAuthStatus(.authAndwaitingForTelegramNumber)
            self.completion()
        }
    }
}
