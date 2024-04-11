//
//  CodeViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol CodeViewProtocol: AnyObject {
    func loadingStart()
    
    func loadingFinish(warning: String?)
}

// MARK: - View Controller
final class CodeViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Введите код 🔗"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Вам в телеграмм пришел код подтверждения."
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var verifyView = UIVerifyView()
    
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
    
    var presenter: CodePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifyView.startAgain()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        verifyView.verifyDelegate = self
        
        view.addSubview(contentView)
        contentView.addSubview(verifyView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(warningLabel)
        contentView.addSubview(activityIndicator)
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(verifyView.snp_topMargin).offset(-100)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(mainLabel.snp_centerYWithinMargins).offset(35)
        }
        
        verifyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(60)
            make.centerY.equalTo(contentView.snp_centerYWithinMargins)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyView.snp_bottomMargin).offset(15)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(verifyView)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height / 3
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

extension CodeViewController: UIVerifyViewDelegate {
    func didFillAllFields(code: String) {
        presenter?.sendCode(code)
    }
}

// MARK: - View Protocol Realization
extension CodeViewController: CodeViewProtocol {
    func loadingStart() {
        view.endEditing(true)
        warningLabel.isHidden = true
        activityIndicator.startAnimating()
        verifyView.alpha = 0
    }
    
    func loadingFinish(warning: String?) {
        verifyView.alpha = 1
        if let warning {
            warningLabel.text = warning
            warningLabel.isHidden = false
        }
        
        activityIndicator.stopAnimating()
        
        verifyView.clearFields()
        verifyView.startAgain()
    }
}
