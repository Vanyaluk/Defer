//
//  PasswordViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol PasswordViewProtocol: AnyObject {
    
}

// MARK: - View Controller
final class PasswordViewController: UIViewController {
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .tintColor
        return button
    }()
    
    var presenter: PasswordPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Введите пароль"
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
extension PasswordViewController: PasswordViewProtocol {
    
}
