//
//  ProjectDetailView.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI

struct ProjectDetailView: View {
    var project: Project
    @State private var tasks: [Task] = []
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(project.title)
                .font(.largeTitle)
                .bold()
            
            Text("Заказчик: \(project.customer)")
            Text("Контактное лицо: \(project.contact_person)")
            Text("Контакты: \(project.contact_data)")
            Text("Описание: \(project.description)")
            Text("Статус: \(project.status)")
            Text("Дата начала: \(project.start_date)")
            Text("Дата завершения: \(project.end_date)")
            
            // Отображение задач по статусам
            if !tasks.isEmpty {
                TaskSectionView(title: "Завершен", tasks: tasks.filter { $0.status == "COMPLETED" })
                TaskSectionView(title: "В процессе", tasks: tasks.filter { $0.status == "INPROGRESS" })
                TaskSectionView(title: "Не начато", tasks: tasks.filter { $0.status == "NOTSTARTED" })
                TaskSectionView(title: "Проверка", tasks: tasks.filter { $0.status == "CHECK" })
            } else {
                Text("Задачи отсутствуют.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Детали проекта")
        .onAppear {
            fetchTasks()
        }
    }

    // Метод для загрузки задач по проекту
    private func fetchTasks() {
        guard let url = URL(string: "https://persiky.ru/task/by-project/\(project.id)"),
              let accessToken = viewModel.getAccessToken() else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedTasks = try JSONDecoder().decode([Task].self, from: data)
                    DispatchQueue.main.async {
                        self.tasks = decodedTasks
                    }
                } catch {
                    print("Ошибка декодирования задач: \(error)")
                }
            } else if let error = error {
                print("Ошибка: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

struct TaskSectionView: View {
    let title: String
    let tasks: [Task]

    var body: some View {
        if !tasks.isEmpty {
            Text(title)
                .font(.headline)
                .padding(.top, 10)
            
            List(tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.subheadline)
                        .bold()
                    if let description = task.description {
                        Text(description)
                            .font(.caption)
                    }
                    Text("Дата начала: \(task.start_date)")
                    Text("Дата завершения: \(task.end_date ?? "Не указана")")
                    Text("Часы: \(task.hours ?? 0)")
                }
                .padding(.vertical, 5)
            }
        }
    }
}
