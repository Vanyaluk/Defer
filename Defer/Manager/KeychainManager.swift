//
//  KeychainManager.swift
//  Defer
//
//  Created by Иван Лукъянычев on 09.04.2024.
//

import UIKit
import Security

protocol KeychainManagerProtocol {
    /// Сохранение ключа
    func saveKey(_ value: String)
    
    /// Извлечение ключа
    func getKey() -> String?
    
    /// Удаление ключа
    func clearKey()
}

final class KeychainManager: KeychainManagerProtocol {
    
    static let shared: KeychainManagerProtocol = KeychainManager()
    
    private init() {}
    
    private let keychainAccount = "DeferAppAccount"
    
    func saveKey(_ value: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: keychainAccount,
                kSecValueData as String: data
            ]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    func getKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data,
               let value = String(data: retrievedData, encoding: .utf8) {
                return value
            }
        }
        
        return nil
    }
    
    func clearKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainAccount
        ]
        SecItemDelete(query as CFDictionary)
    }
}

