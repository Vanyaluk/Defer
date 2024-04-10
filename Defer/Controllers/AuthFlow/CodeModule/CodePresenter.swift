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
    
    func sendCode(_ code: String) {
        view?.loadingStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.view?.loadingFinish(warning: nil)
            self.authManager.changeAuthStatus(.authAndWaitingForTelegramPassword)
            self.completion()
        }
    }
}
