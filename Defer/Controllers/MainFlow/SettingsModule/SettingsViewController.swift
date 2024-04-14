//
//  SettingsViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 10.04.2024
//

import UIKit

// MARK: - View Protocol
protocol SettingsViewProtocol: AnyObject {
    
}

// MARK: - View Controller
final class SettingsViewController: UIViewController {
    
    // UI
    private lazy var exitAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor()
        button.layer.cornerRadius = 13
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    private lazy var exitTelegramButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти из Telegram", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appColor()
        button.layer.cornerRadius = 13
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    var presenter: SettingsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Настройки"
        
        exitAccountButton.addTarget(self, action: #selector(exitAccountButtonTapped), for: .touchUpInside)
        exitTelegramButton.addTarget(self, action: #selector(exitTelegramButtonTapped), for: .touchUpInside)
        
        view.addSubview(exitAccountButton)
        view.addSubview(exitTelegramButton)
        
        exitAccountButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        exitTelegramButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(45)
            make.top.equalTo(exitAccountButton.snp.bottom).offset(20)
        }
    }
    
    @objc private func exitAccountButtonTapped() {
        presenter?.logoutAccount()
    }
    
    @objc private func exitTelegramButtonTapped() {
        presenter?.logoutTelegramSession()
    }
}

// MARK: - View Protocol Realization
extension SettingsViewController: SettingsViewProtocol {
    
}
