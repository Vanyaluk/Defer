//
//  LoginViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol LoginViewProtocol: AnyObject {
    
}

// MARK: - View Controller
final class LoginViewController: UIViewController {
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .tintColor
        return button
    }()
    
    var presenter: LoginPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Войдите в свой аккаунт"
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        let actionContinueButton = UIAction { [weak self] _ in
            self?.presenter?.buttonTapped()
        }
        continueButton.addAction(actionContinueButton, for: .touchUpInside)
    }
}

// MARK: - View Protocol Realization
extension LoginViewController: LoginViewProtocol {
    
}
