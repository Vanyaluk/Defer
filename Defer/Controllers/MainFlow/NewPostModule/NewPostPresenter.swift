//
//  NewPostPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol NewPostPresenterProtocol: AnyObject {
    func viewDidLoaded()
    
    func saveNewPost(channelId: Int64, text: String, date: Date)
    
    func chooseChannel()
    
    func closeView()
}

final class NewPostPresenter {
    weak var view: NewPostViewProtocol?
    var router: NewPostRouterInput
    
    let networkService: NetworkService
    let completion: () -> Void

    init(view: NewPostViewProtocol?, router: NewPostRouterInput, networkService: NetworkService, completion: @escaping () -> Void) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.completion = completion
    }
}

extension NewPostPresenter: NewPostPresenterProtocol {
    func viewDidLoaded() {
        // first setup view
    }
    
    func saveNewPost(channelId: Int64, text: String, date: Date) {
        view?.startLoading()
        let dateInt32 = Int32(date.timeIntervalSince1970)
        Task(priority: .medium) {
            do {
                try await networkService.saveNewPost(channelId: channelId, text: text, date: dateInt32)
                DispatchQueue.main.async {
                    self.completion()
                    self.router.dismissView()
                }
            } catch {
                print(error)
                DispatchQueue.main.async { print("RootInteractorOutput Ошибка i") }
            }
        }
    }
    
    func chooseChannel() {
        router.pushChanelsModule { [weak self] id, channel in
            self?.view?.setChannel(id: id, channel: channel)
        }
    }
    
    func closeView() {
        router.dismissView()
    }
}
