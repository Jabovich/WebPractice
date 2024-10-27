//
//  LoginRequest.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import Foundation

struct LoginRequest: Codable {
    let login: String
    let password: String
}

struct LoginResponse: Codable {
    let access_token: String
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let middleName: String
    let role: String
    let status: String
}
