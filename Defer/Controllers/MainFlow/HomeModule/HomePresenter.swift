//
//  HomePresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol HomePresenterProtocol: AnyObject {
    var avatars: [String: Data] { get }
    
    func fetchAllPostsAndShow(on date: Date)
    
    func showPostsFromCash(on date: Date)
    
    func showPost(post: Components.Schemas.Post, selectedDate: Date)
    
    func showNewPost(on selectedDate: Date)
    
    func showWarningAlert()
    
    func loadAvatars()
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    var router: HomeRouterInput

    let networkService: NetworkService
    var authManager: AuthManagerProtocol
    
    var avatars: [String: Data] {
        get {
            networkService.imageCash
        }
    }
    
    init(view: HomeViewProtocol? = nil, router: HomeRouterInput, networkService: NetworkService, authManager: AuthManagerProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.authManager = authManager
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    func fetchAllPostsAndShow(on date: Date) {
        Task(priority: .medium) {
            do {
                let result = try await networkService.fetchAllPosts()
                if result {
                    DispatchQueue.main.async {
                        self.showPostsFromCash(on: date)
                        self.loadAvatars()
                    }
                } else {
                    DispatchQueue.main.async { print("RootInteractorOutput Ошибка t") }
                }
            } catch {
                DispatchQueue.main.async { print("RootInteractorOutput Ошибка i") }
            }
        }
    }
    
    func showPostsFromCash(on date: Date) {
        // сделать по дням
        var posts = networkService.getCashesPosts(on: date)
        posts.sort { first, second in
            Date(timeIntervalSince1970: TimeInterval(first.date)) < Date(timeIntervalSince1970: TimeInterval(second.date))
        }
        view?.showPosts(posts: posts)
    }
    
    func showPost(post: Components.Schemas.Post, selectedDate: Date) {
        router.pushPostModule(post: post) { [weak self] in
            self?.fetchAllPostsAndShow(on: selectedDate)
        }
    }
    
    func showNewPost(on selectedDate: Date) {
        router.presentNewPostModule { [weak self] in
            self?.fetchAllPostsAndShow(on: selectedDate)
        }
    }
    
    func showWarningAlert() {
        router.presentWarningAlert()
    }
    
    func loadAvatars() {
        let group = DispatchGroup()
        networkService.imageCash.removeAll()
        
        networkService.getCashesPosts().forEach { post in
            group.enter()
            networkService.loadChannelPhoto(id: post.channel.photoId ?? nil) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.view?.showFetchedAvatars()
        }
    }
}
