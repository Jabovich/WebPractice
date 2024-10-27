//
//  ProjectListView.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI

struct ProjectListView: View {
    @State private var projects: [Project] = []
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            List(projects) { project in
                ProjectRowView(project: project)
            }
            .navigationTitle("Проекты")
            .onAppear {
                fetchProjects()
            }
        }
    }

    func fetchProjects() {
        guard let url = URL(string: "https://persiky.ru/project/list") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
    
        if let accessToken = viewModel.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedProjects = try JSONDecoder().decode([Project].self, from: data)
                    DispatchQueue.main.async {
                        self.projects = decodedProjects
                    }
                } catch {
                    print("Ошибка декодирования: \(error)")
                }
            } else if let error = error {
                print("Ошибка: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
