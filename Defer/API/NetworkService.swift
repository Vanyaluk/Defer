//
//  NetworkService.swift
//  Defer
//
//  Created by Иван Лукъянычев on 10.04.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import Network
import HTTPTypes


struct AuthenticationMiddleware: ClientMiddleware {

    /// The token value.
    var bearerToken: String

    func intercept(_ request: HTTPRequest,
                   body: HTTPBody?,
                   baseURL: URL,
                   operationID: String,
                   next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = "Bearer \(bearerToken)"
        return try await next(request, body, baseURL)
    }
}

class NetworkService {
    private var bearerToken = ""
    
    private var posts = [Components.Schemas.Post]()
    
    private var imageCash = [String: Data]()
    
    var client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
    
    // MARK: - Управление токенов в сессии
    /// установить токен для клиента
    /// используется при получении ответа на запрос о регистрации пользователя в сервисе
    private func setBearer(token: String) {
        bearerToken = token
        let middleWare = AuthenticationMiddleware(bearerToken: token)
        client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport(), middlewares: [middleWare])
    }
    
    /// удалить токен у клиента
    func removeBearer() {
        client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
    }
    
    
    // MARK: - Запросы
    /// проверка на привязку телеграмма
    func checkTelegramLinked(token: String) async throws -> String? {
        setBearer(token: token)
        let result = try await client.get_sol_api_sol_telegram_sol_status()
        switch result {
        case .ok(let responce):
            return try responce.body.json.state.rawValue
        case .badRequest(_):
            return nil
        case .undocumented(let statusCode, _):
            return nil
        }
    }
    
    
    /// отправляю номер в телеграм
    func numberTelegram(number: String) async throws -> String? {
        let result = try await client.post_sol_api_sol_telegram_sol_phone(.init(body: .json(.init(phone: number))))
        switch result {
        case .ok(let responce):
            return try responce.body.json.state.rawValue
        case .badRequest(_):
            return nil
        case .undocumented(_, _):
            return nil
        }
    }
    
    
    /// проверка на правильность кода в телеграме
    func codeTelegram(code: String) async throws -> String? {
        let result = try await client.post_sol_api_sol_telegram_sol_code(.init(body: .json(.init(code: code))))
        switch result {
        case .ok(let responce):
            return try responce.body.json.state.rawValue
        case .badRequest(_):
            return nil
        case .undocumented(_, _):
            return nil
        }
    }
    
    
    /// регистрация пользователя в сервисе
    func registration(login: String, password: String) async throws -> String? {
        let result = try await client.post_sol_api_sol_auth_sol_login(.init(body: .json(.init(login: login, password: password))))
        switch result {
        case .ok(let responce):
            let token = try responce.body.json.token
            setBearer(token: token)
            KeychainManager.shared.saveKey(token)
            return token
        case .badRequest(_):
            return nil
        case .undocumented(_, _):
            return nil
        }
    }
    
    
    /// двухфакторная регистрация
    func twoFactorPassword(password: String) async throws -> String? {
        let result = try await client.post_sol_api_sol_telegram_sol_password(.init(body: .json(.init(password: password))))
        switch result {
        case .ok(let responce):
            let token = try responce.body.json.state.rawValue
            return token
        case .badRequest(_):
            return nil
        case .undocumented(_, _):
            return nil
        }
    }
    
    
    /// подгружает все отложенные сообщения
    func fetchAllPosts() async throws -> Bool {
        let result = try await client.get_sol_api_sol_tg_hyphen_interaction_sol_scheduled_posts()
        switch result {
        case .ok(let responce):
            let fetched = try responce.body.json.posts
            posts = fetched
            return true
        case .badRequest(_):
            return false
        case .undocumented(_, _):
            return false
        }
    }
    
    
    /// удаление поста
    func deletePost(channelId: Int64, messageId: Int64) async throws {
        let result = try await client.delete_sol_api_sol_tg_hyphen_interaction_sol_scheduled_posts(.init(body: .json(.init(channelId: channelId, messageIds: [messageId]))))
    }
    
    
    /// подкрузка постов по дате из кеша
    func fetchPosts(of date: Date) -> [Components.Schemas.Post] {
        let dayPosts = posts.filter { post in
            Calendar.current.dateComponents([.year, .month, .day], from: date) == Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: TimeInterval(post.date)))
        }
        return dayPosts
    }
    
    /// выход из сеанса
    func logOutTelegram() async throws -> Bool {
        let result = try await client.patch_sol_api_sol_telegram()
        switch result {
        case .ok(let responce):
            return true
        case .badRequest(_):
            return false
        case .undocumented(_, _):
            return false
        }
    }
    
    
    /// запрос на фото канала
    func getChannelPhoto(id: String, completion: @escaping (String, Data?) -> Void) {
        if let image = imageCash[id] {
            completion(id, image)
            return
        }
        
        let stringURL = "https://prod-uuu-backend.freemyip.com/api/tg-files/\(id)"
        if let url = URL(string: stringURL) {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Authorization": "Bearer \(bearerToken)"
            ]
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                } else {
                    if let data = data {
                        self.imageCash[id] = data
                        completion(id, data)
                    }
                }
            }.resume()
        }
    }
    
    
    /// подгрузка всех каналов
    func fetchedAllChannels() async throws -> [Components.Schemas.Channel] {
        let result = try await client.get_sol_api_sol_tg_hyphen_interaction_sol_available_to_write_channels()
        switch result {
        case .ok(let responce):
            return try responce.body.json.channels
        case .badRequest(_):
            return []
        case .undocumented(_, _):
            return []
        }
    }
    
    
    /// создание нового поста
    func saveNewPost(channelId: Int64, text: String, date: Int32) async throws {
        let result = try await client.put_sol_api_sol_tg_hyphen_interaction_sol_create_scheduled_post(.init(body: .json(.init(channelId: channelId, text: text, date: date))))
    }
}
