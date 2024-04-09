//
//  CodePresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol CodePresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func buttonTapped()
}

final class CodePresenter {
    weak var view: CodeViewProtocol?
    
    let authManager: AuthManagerProtocol
    var completion: () -> Void

    init(view: CodeViewProtocol, authManager: AuthManagerProtocol, completion: @escaping () -> Void) {
        self.view = view
        self.authManager = authManager
        self.completion = completion
    }
}

extension CodePresenter: CodePresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func buttonTapped() {
        // TODO: запрос за статусом на сервер
        authManager.changeAuthStatus(.authAndWaitingForTelegramPassoword)
        completion()
    }
}
