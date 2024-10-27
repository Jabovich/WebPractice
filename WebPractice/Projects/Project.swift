//
//  Project.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import Foundation

struct Project: Identifiable, Codable {
    let id: Int
    let title: String
    let owner_id: Int?
    let director: String?
    let customer: String
    let contact_person: String
    let contact_data: String
    let description: String
    let service_name: String?
    let document_number: Int
    let contract: String?
    let contract_date: String?
    let technical_task: String?
    let comment: String?
    let start_date: String
    let end_date: String
    let organization_id: Int?
    let status: String
    var tasks: [Task]? // Added tasks property for storing related tasks
}

struct Task: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String?
    let start_date: String
    let end_date: String?
    let is_done: Bool
    let project_id: Int
    let comment: String?
    let reviewer_id: Int?
    let executor_id: Int?
    let status: String
    let hours: Int?
}
