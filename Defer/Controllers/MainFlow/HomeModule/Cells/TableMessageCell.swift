//
//  TableMessageCell.swift
//  Defer
//
//  Created by Иван Лукъянычев on 13.04.2024.
//

import UIKit


class TableMessageCell: UITableViewCell {
    
    static let id: String = "tableMessageCell"
    
    // UI
    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var warningNearButton: UIButton = {
        let button = UIButton()
        button.setTitle("⚠️", for: .normal)
        button.addTarget(self, action: #selector(warningNearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var networkService: NetworkService?
    
    weak var viewController: HomeViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: Components.Schemas.Post?
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(cellView)
        cellView.addSubview(logoView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(dateLabel)
        cellView.addSubview(warningNearButton)
        cellView.addSubview(messageLabel)
        
        cellView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.top.equalToSuperview().offset(14)
        }
            
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalTo(logoView.snp.centerY)
            make.width.equalTo(45)
        }
            
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoView.snp.trailing).offset(7)
            make.centerY.equalTo(logoView.snp.centerY)
            make.trailing.equalTo(dateLabel.snp.leading).inset(7)
        }
        
        warningNearButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.width.equalTo(30)
            make.top.equalTo(logoView.snp.bottom)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(warningNearButton.snp.leading).offset(-4)
            make.top.equalTo(logoView.snp.bottom).offset(9)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(14)
        }
    }
    
    func configure(_ temp: Components.Schemas.Post, imageData: Data?) {
        post = temp
        
        nameLabel.text = temp.channel.title
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(temp.date)))
        let min = calendar.component(.minute, from: Date(timeIntervalSince1970: TimeInterval(temp.date)))
        dateLabel.text = "\(fn(hour)):\(fn(min))"
        messageLabel.text = temp.text ?? ""
        logoView.image = UIImage(data: imageData ?? Data())
    }
    
    private func fn(_ number: Int) -> String {
        if number < 10 {
            return String(format: "0%d", number)
        } else {
            return String(number)
        }
    }
    
    func setWarning(_ bool: Bool) {
        warningNearButton.isHidden = !bool
    }
    
    @objc private func warningNearButtonTapped() {
        viewController?.warningButtonTapped()
    }
}


