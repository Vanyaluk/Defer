//
//  NumberPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol NumberPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func buttonTapped()
}

final class NumberPresenter {
    weak var view: NumberViewProtocol?
    
    let authManager: AuthManagerProtocol
    var completion: () -> Void

    init(view: NumberViewProtocol, authManager: AuthManagerProtocol, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.completion = completion
    }
}

extension NumberPresenter: NumberPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func buttonTapped() {
        // TODO: запрос за статусом на сервер
        authManager.changeAuthStatus(.authAndWaitingForTelegramCode)
        completion()
    }
}
