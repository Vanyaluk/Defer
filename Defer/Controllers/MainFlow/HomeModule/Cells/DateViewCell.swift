//
//  DateViewCell.swift
//  Defer
//
//  Created by Иван Лукъянычев on 11.04.2024.
//

import UIKit
import SnapKit

class DateViewCell: UICollectionViewCell {
    
    static let id: String = "cell1"
    
    // UI
    lazy var number: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var circle: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 17
        view.clipsToBounds = true
        view.backgroundColor = .app()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(circle)
        circle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(34)
        }
        
        contentView.addSubview(number)
        number.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func setup(isSelected: Bool, isToday: Bool) {
        circle.alpha = 0
        number.textColor = .label
        
        if isSelected {
            UIView.animate(withDuration: 0.2) {
                self.circle.alpha = 1
                self.number.textColor = .white
            }
        }
        
        if isToday && !isSelected {
            number.textColor = .systemRed
        }
    }
}


