//
//  UsersViewModel.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI
import Combine

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?

    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            errorMessage = "Неверный URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Ошибка: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "Данные не найдены"
                }
                return
            }

            do {
                let decodedUsers = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = decodedUsers
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Ошибка декодирования данных: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
