//
//  NumberViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol NumberViewProtocol: AnyObject {
    func loadingStart()
    
    func loadingFinish(warning: String?)
}

// MARK: - View Controller
final class NumberViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Телефон ☎️"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона, от вашего Telegram аккаунта"
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var numberField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.placeholder = "+7 (000) 000-00-00"
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 30, weight: .semibold)
        return field
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .app()
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
    
    var presenter: NumberPresenterProtocol?

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
        
        if let _ = KeychainManager.shared.getKey() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .done, target: self, action: #selector(logoutButtonTapped))
        }
        
        numberField.delegate = self
        
        view.addSubview(contentView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(numberField)
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
            make.bottom.equalTo(numberField.snp_topMargin).offset(-100)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(mainLabel.snp_centerYWithinMargins).offset(35)
        }
        
        numberField.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.centerY.equalTo(contentView.snp_centerYWithinMargins)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(numberField.snp_bottomMargin).offset(15)
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
    
    @objc private func logoutButtonTapped() {
        presenter?.logoutAccount()
    }
    
    @objc private func continueButtonTapped() {
        presenter?.buttonTapped(number: numberField.text ?? "")
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
extension NumberViewController: NumberViewProtocol {
    func loadingStart() {
        view.endEditing(true)
        continueButton.isHidden = true
        activityIndicator.startAnimating()
        warningLabel.isHidden = true
        numberField.isEnabled = false
    }
    
    func loadingFinish(warning: String?) {
        continueButton.isHidden = false
        activityIndicator.stopAnimating()
        numberField.isEnabled = true
        if let warning {
            warningLabel.text = warning
            warningLabel.isHidden = false
        }
    }
}


// MARK: - UITextFieldDelegate Realization
extension NumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+X (XXX) XXX-XX-XX", phone: newString)
        return false
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)

            } else {
                result.append(ch)
            }
        }
        return result
    }
}
