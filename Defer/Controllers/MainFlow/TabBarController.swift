//
//  TabBarController.swift
//  Defer
//
//  Created by Иван Лукъянычев on 10.04.2024.
//

import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var homeNavigationController: UINavigationController = {
        let view = UINavigationController()
        view.tabBarItem.title = "Главная"
        view.tabBarItem.image = UIImage(systemName: "list.bullet.below.rectangle")
        return view
    }()
    
    private lazy var settingsNavigationController: UINavigationController = {
        let view = UINavigationController()
        view.tabBarItem.title = "Настройки"
        view.tabBarItem.image = UIImage(systemName: "gear")
        return view
    }()
    
    let networkService: NetworkService
    var authManager: AuthManagerProtocol
    var completion: () -> Void
    
    init(networkService: NetworkService, authManager: AuthManagerProtocol, completion: @escaping () -> Void) {
        self.networkService = networkService
        self.authManager = authManager
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupUI()
        checkTelegramStatus()
    }
    
    private func setupTabBar() {
        setViewControllers([
            homeNavigationController,
            settingsNavigationController
        ], animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension TabBarController {
    private func checkTelegramStatus() {
        activityIndicator.startAnimating()
        
        guard let token = KeychainManager.shared.getKey() else {
            authManager.setAuthStatus(.notAuth)
            completion()
            return
        }
        
        Task(priority: .medium) {
            do {
                let result = try await networkService.checkTelegramLinked(token: token)
                if let result {
                    DispatchQueue.main.async {
                        self.resultParsing(result: result)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func resultParsing(result: String) {
        activityIndicator.stopAnimating()
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
            showControllers()
        }
    }
    
    private func showControllers() {
        let homeVc = HomeAssembly(networkService: networkService, authManager: authManager).assemble()
        homeNavigationController.pushViewController(homeVc, animated: false)
        
        let settingsVc = SettingsAssembly(networkService: networkService, authManager: authManager).assemble(completion: completion)
        settingsNavigationController.pushViewController(settingsVc, animated: false)
    }
}
