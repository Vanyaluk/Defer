//
//  UISettingsButton.swift
//  Defer
//
//  Created by Иван Лукъянычев on 19.04.2024.
//

import UIKit

class UISettingsButton: UIButton {
    
    private let title: String
    private let systemImage: String
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = title
        return label
    }()
    
    private lazy var mainImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: systemImage)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mainImage, mainLabel])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 10
        view.isUserInteractionEnabled = false
        return view
    }()
    

    init(title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 13
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
    }
}
