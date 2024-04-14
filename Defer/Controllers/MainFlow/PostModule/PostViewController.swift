//
//  PostViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol PostViewProtocol: AnyObject {
    func startLoading()
    
    func finishLoading()
}

// MARK: - View Controller
final class PostViewController: UIViewController {
    
    // UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 11, weight: .light)
        return label
    }()
    
    private lazy var telegramButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти в Telegram", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 14
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(telegramButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    var post: Components.Schemas.Post
    
    var presenter: PostPresenterProtocol?
    
    init(post: Components.Schemas.Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextsForLabels()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonTapped))
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(postTextLabel)
        postTextLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(16)
        }
        
        scrollView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(postTextLabel.snp.bottom).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).inset(12)
        }
        
        scrollView.addSubview(telegramButton)
        telegramButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(50)
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    private func configureTextsForLabels() {
        title = post.channel.title
        postTextLabel.text = post.text
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(post.date)))
        let min = calendar.component(.minute, from: Date(timeIntervalSince1970: TimeInterval(post.date)))
        let day = calendar.component(.day, from: Date(timeIntervalSince1970: TimeInterval(post.date)))
        let month = calendar.component(.month, from: Date(timeIntervalSince1970: TimeInterval(post.date)))
        let year = calendar.component(.year, from: Date(timeIntervalSince1970: TimeInterval(post.date)))
        dateLabel.text = "\(fn(day)).\(fn(month)).\(year) \(fn(hour)):\(fn(min))"
    }
    
    private func fn(_ number: Int) -> String {
        if number < 10 {
            return String(format: "0%d", number)
        } else {
            return String(number)
        }
    }
    
    @objc private func telegramButtonTapped() {
        if let link = post.channel.inviteLink {
            if let url = URL(string: link) {
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    @objc private func deleteButtonTapped() {
        presenter?.showDeletingSheet(channelId: post.channel.id, messageId: post.id)
    }
}

// MARK: - View Protocol Realization
extension PostViewController: PostViewProtocol {
    func startLoading() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        loader.startAnimating()
        scrollView.alpha = 0
    }
    
    func finishLoading() {
        loader.stopAnimating()
        scrollView.alpha = 1
    }
    
    
}
