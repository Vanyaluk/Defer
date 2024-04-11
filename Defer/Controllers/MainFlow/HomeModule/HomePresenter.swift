//
//  HomePresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoaded()
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    var router: HomeRouterInput

    let networkService: NetworkService
    var authManager: AuthManagerProtocol
    
    init(view: HomeViewProtocol? = nil, router: HomeRouterInput, networkService: NetworkService, authManager: AuthManagerProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.authManager = authManager
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    func viewDidLoaded() {
        
    }
}
