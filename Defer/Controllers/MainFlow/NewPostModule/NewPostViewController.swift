//
//  NewPostViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol NewPostViewProtocol: AnyObject {
    func setChannel(id: Int64, channel: String)
    
    func startLoading()
}

// MARK: - View Controller
final class NewPostViewController: UIViewController {
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date.now.addingTimeInterval(960)
        return picker
    }()
    
    private lazy var contentView1: UIButton = {
        let view = UIButton()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(choiseNewChanelsButtonTapped), for: .touchUpInside)
        return view
    }()
    
    
    private lazy var choiseChannelButton: UILabel = {
        let button = UILabel()
        button.text = "Выбрать каналы:"
        return button
    }()
    
    private lazy var chanelLabel: UILabel = {
        let label = UILabel()
        label.text = "Не выбрано"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var postTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.font = .systemFont(ofSize: 16)
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    var presenter: NewPostPresenterProtocol?
    
    private var channelId: Int64?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Новый пост"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        navigationItem.backButtonTitle = "Назад"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(contentView1)
        contentView1.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        contentView1.addSubview(choiseChannelButton)
        choiseChannelButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        contentView1.addSubview(chanelLabel)
        chanelLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.trailing.equalToSuperview().inset(15)
        }
        
        view.addSubview(postTextView)
        postTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
            make.top.equalTo(contentView1.snp.bottom).offset(10)
        }
        
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let channelId else { return }
        guard !postTextView.text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        guard datePicker.date > .now else { return }
        presenter?.saveNewPost(channelId: channelId, text: postTextView.text, date: datePicker.date)
    }
    
    @objc private func choiseNewChanelsButtonTapped() {
        presenter?.chooseChannel()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - View Protocol Realization
extension NewPostViewController: NewPostViewProtocol {
    func setChannel(id: Int64, channel: String) {
        channelId = id
        chanelLabel.text = channel
    }
    
    func startLoading() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        loader.startAnimating()
        datePicker.alpha = 0
        contentView1.alpha = 0
        postTextView.alpha = 0
    }
}
