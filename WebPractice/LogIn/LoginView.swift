//
//  LoginView.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var login: String = ""
    @State private var password: String = ""
    
    var myViolet = Color(red: 0.4745098039215686,
                         green: 0.4745098039215686,
                         blue: 0.8784313725490196)
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Добро пожаловать!")
                    .font(.largeTitle)
                    .bold()
                
                Text("Введите ваши данные")
                    .font(.caption)
                    .opacity(0.8)
                    .padding(.bottom)
                
                TextField("Логин", text: $login)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(myViolet).opacity(0.1))
                    .cornerRadius(20.0)
                
                SecureField("Пароль", text: $password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(myViolet).opacity(0.1))
                    .cornerRadius(20.0)

                Button(action: {
                    viewModel.loginUser(login: login, password: password)
                }) {
                    Text("Войти")
                        .frame(width: 300, height: 50)
                        .background(Color(myViolet))
                        .foregroundColor(.white)
                        .cornerRadius(20.0)
                        .padding(.horizontal)
                }
                
                
                if let errorMessage = viewModel.errorMessage {
                    Text((errorMessage))
                        .foregroundColor(.red)
                        .frame(width: 300)
                }
            }
            
            .navigationDestination(
                isPresented: $viewModel.isLoggedIn,
                destination: {
                    //ContentView()
                    ProjectListView()
                }
            )
        }
    }
}

#Preview {
    ProjectListView()
}
