//
//  PostPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol PostPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func deletePost(channelId: Int64, messageId: Int64)
}

final class PostPresenter {
    weak var view: PostViewProtocol?
    var router: PostRouterInput
    
    let networkService: NetworkService
    let completion: () -> Void  // для перезегрузки home view

    init(view: PostViewProtocol?, router: PostRouterInput, networkService: NetworkService, completion: @escaping () -> Void) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.completion = completion
    }
}

extension PostPresenter: PostPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func deletePost(channelId: Int64, messageId: Int64) {
        view?.startLoading()
        Task(priority: .medium) {
            do {
                try await networkService.deletePost(channelId: channelId, messageId: messageId)
                DispatchQueue.main.async {
                    self.completion()
                    self.router.dismissView()
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.finishLoading()
                }
            }
        }
    }
}
