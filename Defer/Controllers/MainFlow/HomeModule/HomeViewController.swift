//
//  HomeViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

// MARK: - View Protocol
protocol HomeViewProtocol: AnyObject {
    
}

// MARK: - View Controller
final class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .yellow
    }
}

// MARK: - View Protocol Realization
extension HomeViewController: HomeViewProtocol {
    
}
