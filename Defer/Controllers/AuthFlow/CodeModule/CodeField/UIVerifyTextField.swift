//
//  UIVerifyTextField.swift
//  Defer
//
//  Created by Иван Лукъянычев on 10.04.2024.
//

import UIKit

protocol UIVerifyTextFieldDelegate: AnyObject {
    func activeNextField(tag: Int)
    
    func activePreviosField(tag: Int)
}


final class UIVerifyTextField: UITextField {
    
    weak var fieldDelegate: UIVerifyTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        tintColor = .clear
        layer.borderColor = UIColor.app().cgColor
        textColor = .label
        font = .systemFont(ofSize: 35, weight: .semibold)
        textAlignment = .center
        delegate = self
        keyboardType = .numberPad
    }
    
    override func deleteBackward() {
        fieldDelegate?.activePreviosField(tag: tag)
    }
}

extension UIVerifyTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        text = string
        
        if range.length == 0 {
            fieldDelegate?.activeNextField(tag: tag)
            resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.layer.borderWidth = 2
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.layer.borderWidth = 0
        }
    }
}

