//
//  AuthViewModel.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI
import Combine
import Security

class AuthViewModel: ObservableObject {
    @Published var loginResponse: LoginResponse?
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    func loginUser(login: String, password: String) {
        guard let url = URL(string: "https://persiky.ru/auth/login") else {
            self.errorMessage = "Неверный URL"
            return
        }
        
        let loginRequest = LoginRequest(login: login, password: password)
        guard let jsonData = try? JSONEncoder().encode(loginRequest) else {
            self.errorMessage = "Ошибка кодирования данных"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let workItem = DispatchWorkItem {
                    self.errorMessage = "Ошибка: \(error.localizedDescription)"
                }
                DispatchQueue.main.async(execute: workItem)
                return
            }
            
            guard let data = data else {
                let workItem = DispatchWorkItem {
                    self.errorMessage = "Нет данных в ответе"
                }
                DispatchQueue.main.async(execute: workItem)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                let workItem = DispatchWorkItem {
                    self.loginResponse = decodedResponse
                    self.saveAccessToken(decodedResponse.access_token)
                    self.isLoggedIn = true
                }
                DispatchQueue.main.async(execute: workItem)
            } catch {
                let workItem = DispatchWorkItem {
                    self.errorMessage = "Ошибка декодирования ответа: \(error.localizedDescription)"
                }
                DispatchQueue.main.async(execute: workItem)
            }
        }.resume()
    }
    
    // MARK: - Keychain Methods
    
    func saveAccessToken(_ token: String) {
        let data = Data(token.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecValueData: data
        ] as CFDictionary
        
        // Удаляем старое значение, если оно существует
        SecItemDelete(query)
        
        // Сохраняем новое значение
        let status = SecItemAdd(query, nil)
        if status == errSecSuccess {
            print("Токен сохранен успешно")
        } else {
            print("Ошибка сохранения токена: \(status)")
        }
    }

    func getAccessToken() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("Ошибка извлечения токена: \(status)")
            return nil
        }
    }

    func deleteAccessToken() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken"
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        if status == errSecSuccess {
            print("Токен успешно удален")
        } else {
            print("Ошибка удаления токена: \(status)")
        }
    }
}
