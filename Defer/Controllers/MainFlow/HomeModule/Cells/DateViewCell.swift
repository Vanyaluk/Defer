//
//  DateViewCell.swift
//  Defer
//
//  Created by Иван Лукъянычев on 11.04.2024.
//

import UIKit

class DateViewCell: UICollectionViewCell {
    
    static let id: String = "cell1"
    
    // UI
    lazy var number: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var circle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.backgroundColor = .appColor()
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
        circle.layer.cornerRadius = contentView.frame.height / 2
        
        contentView.addSubview(circle)
        contentView.addSubview(number)
        
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: contentView.topAnchor),
            circle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            circle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            circle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            number.topAnchor.constraint(equalTo: contentView.topAnchor),
            number.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            number.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            number.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
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
        
        if isToday {
            number.textColor = .systemRed
        }
    }
}


