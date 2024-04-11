//
//  HomeViewController.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

// MARK: - View Protocol
protocol HomeViewProtocol: AnyObject {
    func loadingStart()
    
    func loadingFinish(warning: String?)
}

// MARK: - View Controller
final class HomeViewController: UIViewController {
    
    private lazy var collectionDatesView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let itemWidth = (view.frame.size.width - 80.0) / 7
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(DateViewCell.self, forCellWithReuseIdentifier: DateViewCell.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var presenter: HomePresenterProtocol?
    
    private var selectedDate = Date()
    private var totalSquares = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right.circle"), style: .plain, target: self, action: #selector(nextWeek))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle"), style: .plain, target: self, action: #selector(lastWeek))
        
        collectionDatesView.delegate = self
        collectionDatesView.dataSource = self
        
        view.addSubview(collectionDatesView)
        collectionDatesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        setWeekView()
    }
    
    private func setWeekView() {
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while current < nextSunday {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        navigationItem.title = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionDatesView.reloadData()
//        tableMessagesView.reloadData()
    }
    
    @objc private func lastWeek() {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
//        presenter?.getPosts(with: selectedDate)
    }
    
    @objc private func nextWeek() {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
//        presenter?.getPosts(with: selectedDate)
    }
}

// MARK: - View Protocol Realization
extension HomeViewController: HomeViewProtocol {
    func loadingStart() {
        
    }
    
    func loadingFinish(warning: String?) {
        
    }
}


// MARK: - UICollectionView Realization
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateViewCell.id, for: indexPath) as? DateViewCell else { return UICollectionViewCell() }
        
        let date = totalSquares[indexPath.item]
        
        let isToday = Calendar.current.dateComponents([.year, .month, .day], from: Date.now) == Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        cell.number.text = String(CalendarHelper().dayOfMonth(date: date))
        cell.setup(isSelected: date == selectedDate, isToday: isToday)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        collectionDatesView.reloadData()
//        presenter?.getPosts(with: selectedDate)
    }
}
