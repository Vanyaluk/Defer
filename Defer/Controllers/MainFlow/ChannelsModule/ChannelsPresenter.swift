//
//  ChannelsPresenter.swift
//  Super easy dev
//
//  Created by vanyaluk on 14.04.2024
//

import UIKit

protocol ChannelsPresenterProtocol: AnyObject {
    func fetchAllChannels()
    
    func didSelectRow(id: Int64, title: String)
}

final class ChannelsPresenter {
    weak var view: ChannelsViewProtocol?
    var router: ChannelsRouterInput
    
    let networkService: NetworkService
    let completion: (Int64, String) -> Void

    init(view: ChannelsViewProtocol, router: ChannelsRouterInput, networkService: NetworkService, completion: @escaping (Int64, String) -> Void) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.completion = completion
    }
}

extension ChannelsPresenter: ChannelsPresenterProtocol {
    func fetchAllChannels() {
        Task(priority: .medium) {
            do {
                let channels = try await networkService.fetchedAllChannels()
                DispatchQueue.main.async {
                    self.view?.showChannels(fetched: channels)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func didSelectRow(id: Int64, title: String) {
        completion(id, title)
        router.dismiss()
    }
}
