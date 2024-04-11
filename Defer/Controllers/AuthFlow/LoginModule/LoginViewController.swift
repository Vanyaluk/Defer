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
    func loadingStart()
    
    func loadingFinish(warning: String?)
}

// MARK: - View Controller
final class LoginViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Привет👋"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Создайте или введите существующие данные для входа в наш сервис."
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loginField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftViewMode = .always
        field.layer.cornerRadius = 13
        field.layer.cornerCurve = .continuous
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Логин"
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Пароль"
        field.isSecureTextEntry = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftViewMode = .always
        field.layer.cornerRadius = 13
        field.layer.cornerCurve = .continuous
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 13
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ошибка"
        label.textColor = .red
        label.isHidden = true
        label.numberOfLines = 2
        return label
    }()
    
    var presenter: LoginPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        view.addSubview(contentView)
        contentView.addSubview(loginField)
        contentView.addSubview(mainLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(passwordField)
        contentView.addSubview(warningLabel)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(continueButton)
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(loginField.snp_topMargin).offset(-100)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(mainLabel.snp_centerYWithinMargins).offset(35)
        }
        
        loginField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp_centerYWithinMargins).offset(-5)
        }
        
        passwordField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(contentView.snp_centerYWithinMargins).offset(5)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp_bottomMargin).offset(15)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(continueButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func continueButtonTapped() {
        presenter?.loginUser(login: loginField.text ?? "", password: passwordField.text ?? "")
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height - view.safeAreaInsets.bottom + 15
            contentView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardHeight)
            }

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        contentView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - View Protocol Realization
extension LoginViewController: LoginViewProtocol {
    func loadingStart() {
        view.endEditing(true)
        continueButton.isHidden = true
        activityIndicator.startAnimating()
        warningLabel.isHidden = true
        loginField.isEnabled = false
        passwordField.isEnabled = false
    }
    
    func loadingFinish(warning: String?) {
        continueButton.isHidden = false
        activityIndicator.stopAnimating()
        loginField.isEnabled = true
        passwordField.isEnabled = true
        if let warning {
            warningLabel.text = warning
            warningLabel.isHidden = false
        }
    }
}
