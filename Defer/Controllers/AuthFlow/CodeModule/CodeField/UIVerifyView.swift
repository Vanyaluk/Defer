//
//  UIVerifyView.swift
//  Defer
//
//  Created by Иван Лукъянычев on 10.04.2024.
//

import UIKit
import SnapKit

protocol UIVerifyViewDelegate: AnyObject {
    func didFillAllFields(code: String)
}

final class UIVerifyView: UIView {
    
    weak var verifyDelegate: UIVerifyViewDelegate?
    
    var fieldStack = UIStackView()
    var verifyTextFields = [UIVerifyTextField]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        fieldStack.spacing = 5
        fieldStack.distribution = .fillEqually
        
        for number in 0...4 {
            let field = UIVerifyTextField()
            field.tag = number
            field.fieldDelegate = self
            verifyTextFields.append(field)
            fieldStack.addArrangedSubview(field)
        }
        
        addSubview(fieldStack)
        fieldStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    private func getFieldsCode() -> String {
        var code = ""
        verifyTextFields.forEach {
            code.append($0.text ?? "")
        }
        return code
    }
    
    func clearFields() {
        verifyTextFields.forEach { field in
            field.text = ""
        }
    }
    
    func startAgain() {
        verifyTextFields[0].becomeFirstResponder()
    }
}

extension UIVerifyView: UIVerifyTextFieldDelegate {
    func activeNextField(tag: Int) {
        if tag != verifyTextFields.count - 1 {
            verifyTextFields[tag + 1].becomeFirstResponder()
        } else {
            verifyDelegate?.didFillAllFields(code: getFieldsCode())
        }
    }
    
    func activePreviosField(tag: Int) {
        if tag != 0 {
            verifyTextFields[tag - 1].text = ""
            verifyTextFields[tag - 1].becomeFirstResponder()
        }
    }
    
    
}

