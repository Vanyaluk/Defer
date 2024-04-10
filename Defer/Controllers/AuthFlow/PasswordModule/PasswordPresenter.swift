//
//  PasswordPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol PasswordPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func buttonTapped()
}

final class PasswordPresenter {
    weak var view: PasswordViewProtocol?
    
    let authManager: AuthManagerProtocol
    var completion: () -> Void

    init(view: PasswordViewProtocol, authManager: AuthManagerProtocol, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.completion = completion
    }
}

extension PasswordPresenter: PasswordPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func buttonTapped() {
        // TODO: запрос за статусом на сервер
        
        view?.loadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view?.loadingFinish(warning: nil)
            self.authManager.changeAuthStatus(.authAndHaveTelegram)
            self.completion()
        }
    }
}
