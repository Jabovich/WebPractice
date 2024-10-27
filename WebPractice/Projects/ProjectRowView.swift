//
//  ProjectRowView.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI

struct ProjectRowView: View {
    var project: Project
    @State private var showSheet: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(project.title)
                        .font(.headline)
                    
                    
                    Button(action: {
                        showSheet.toggle() }) {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("Заказчик: \(project.customer)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
        .sheet(isPresented: $showSheet) {
            ProjectDetailView(project: project)
                .presentationDetents([.fraction(0.5), .large])
        }
    }
}
