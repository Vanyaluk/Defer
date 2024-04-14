//
//  HomePresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 09.04.2024
//

import UIKit

protocol HomePresenterProtocol: AnyObject {
    func fetchAllPostsAndShow(on date: Date)
    
    func showPostsFromCash(on date: Date)
    
    func showPost(post: Components.Schemas.Post, selectedDate: Date)
    
    func showNewPost(on selectedDate: Date)
    
    func showWarningAlert()
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    var router: HomeRouterInput

    let networkService: NetworkService
    var authManager: AuthManagerProtocol
    
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
        var posts = networkService.getCahesPosts(on: date)
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
}
