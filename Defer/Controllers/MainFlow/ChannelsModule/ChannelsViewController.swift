//
//  ChannelsViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit
import SnapKit

// MARK: - View Protocol
protocol ChannelsViewProtocol: AnyObject {
    func showChannels(fetched: [Components.Schemas.Channel])
}

// MARK: - View Controller
final class ChannelsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    private var channels = [Components.Schemas.Channel]()
    
    var presenter: ChannelsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.fetchAllChannels()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        title = "Выберите канал"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        loader.startAnimating()
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - View Protocol Realization
extension ChannelsViewController: ChannelsViewProtocol {
    func showChannels(fetched: [Components.Schemas.Channel]) {
        loader.stopAnimating()
        channels.removeAll()
        channels.append(contentsOf: fetched)
        tableView.reloadData()
    }
}


extension ChannelsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = channels[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chn = channels[indexPath.row]
        presenter?.didSelectRow(id: chn.id, title: chn.title)
        navigationController?.popViewController(animated: true)
    }
}
