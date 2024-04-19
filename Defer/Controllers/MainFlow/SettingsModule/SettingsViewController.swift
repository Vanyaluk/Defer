//
//  SettingsViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 10.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol SettingsViewProtocol: AnyObject {
    
}

// MARK: - View Controller
final class SettingsViewController: UIViewController {
    
    // UI
    private lazy var exitAccountButton = UISettingsButton(title: "Выйти из аккаунта", systemImage: "rectangle.portrait.and.arrow.forward")
    
    private lazy var exitAccountDescription: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "Вы выйдете из аккаунта, но Telegram сессия останется активной. Войти можно будет с помощью логина и пароля, надеюсь вы их не забыли."
        return label
    }()
    
    private lazy var exitTelegramButton = UISettingsButton(title: "Завершить Telegram сессию", systemImage: "ipad.and.iphone")
    
    private lazy var exitTelegramDescription: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "Желательно заканчивать сессию именно таким образом. Если сделать это через в Telegram, то будут проблемы с дальнейшем подключением и аккаунт придется сменить."
        return label
    }()
    
    var presenter: SettingsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Настройки"
        
        exitAccountButton.addTarget(self, action: #selector(exitAccountButtonTapped), for: .touchUpInside)
        exitTelegramButton.addTarget(self, action: #selector(exitTelegramButtonTapped), for: .touchUpInside)
        
        view.addSubview(exitAccountButton)
        view.addSubview(exitAccountDescription)
        view.addSubview(exitTelegramButton)
        view.addSubview(exitTelegramDescription)
        
        exitAccountButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        exitAccountDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(exitAccountButton.snp.bottom).offset(7)
        }
        
        exitTelegramButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(45)
            make.top.equalTo(exitAccountDescription.snp.bottom).offset(20)
        }
        
        exitTelegramDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(exitTelegramButton.snp.bottom).offset(7)
        }
    }
    
    @objc private func exitAccountButtonTapped() {
        presenter?.logoutAccountAlert()
    }
    
    @objc private func exitTelegramButtonTapped() {
        presenter?.logoutTelegramSessionAlert()
    }
}

// MARK: - View Protocol Realization
extension SettingsViewController: SettingsViewProtocol {
    
}
