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
    
    func showPosts(posts: [Components.Schemas.Post])
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
    
    private lazy var tableMessagesView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TableMessageCell.self, forCellReuseIdentifier: TableMessageCell.id)
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let spinner = UIRefreshControl()
        spinner.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        return spinner
    }()
    
    private lazy var addNewPostButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(addNewPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var presenter: HomePresenterProtocol?
    
    private var nowdayPosts = [Components.Schemas.Post]()
    
    private var selectedDate = Date()
    private var totalSquares = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.fetchAllPostsAndShow(on: selectedDate)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.right.circle"), style: .plain, target: self, action: #selector(nextWeek))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle"), style: .plain, target: self, action: #selector(lastWeek))
        
        navigationItem.backButtonTitle = "Назад"
        
        collectionDatesView.delegate = self
        collectionDatesView.dataSource = self
        
        tableMessagesView.dataSource = self
        tableMessagesView.delegate = self
        
        tableMessagesView.refreshControl = refreshControl
        
        view.addSubview(collectionDatesView)
        collectionDatesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(tableMessagesView)
        tableMessagesView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(collectionDatesView.snp.bottom)
        }
        
        view.addSubview(addNewPostButton)
        addNewPostButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(13)
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
        tableMessagesView.reloadData()
    }
    
    private func isSetWarning(post: Components.Schemas.Post) -> Bool {
        let cellDate = Date(timeIntervalSince1970: TimeInterval(post.date))
        var isWarning: Bool = false
        var warnings: Int = 0
        nowdayPosts.forEach { post in
            let postDate = Date(timeIntervalSince1970: TimeInterval(post.date))
            if cellDate.addingTimeInterval(-3600) < postDate && cellDate.addingTimeInterval(3600) > postDate {
                if post.channel.id == post.channel.id {
                    warnings += 1
                }
                
            }
        }
        
        if warnings > 1 {
            isWarning = true
        }
        
        return isWarning
    }
    
    @objc private func lastWeek() {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
        presenter?.showPostsFromCash(on: selectedDate)
    }
    
    @objc private func nextWeek() {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
        presenter?.showPostsFromCash(on: selectedDate)
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl) {
        presenter?.fetchAllPostsAndShow(on: selectedDate)
    }
    
    @objc private func addNewPostButtonTapped() {
        presenter?.showNewPost(on: selectedDate)
    }
}


// MARK: - View Protocol Realization
extension HomeViewController: HomeViewProtocol {
    func loadingStart() {
        
    }
    
    func loadingFinish(warning: String?) {
        
    }
    
    func showPosts(posts: [Components.Schemas.Post]) {
        refreshControl.endRefreshing()
        nowdayPosts.removeAll()
        nowdayPosts.append(contentsOf: posts)
        tableMessagesView.reloadData()
    }
}



// MARK: - UICollectionView Realization
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableMessageCell.id, for: indexPath) as? TableMessageCell else { return UITableViewCell()}
        
        cell.configure(nowdayPosts[indexPath.row])
        cell.setWarning(isSetWarning(post: nowdayPosts[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowdayPosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showPost(post: nowdayPosts[indexPath.row], selectedDate: selectedDate)
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
        presenter?.showPostsFromCash(on: selectedDate)
    }
}
