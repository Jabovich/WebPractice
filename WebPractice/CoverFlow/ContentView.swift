//
//  ContentView.swift
//  WebPractice
//
//  Created by Андрей Сметанин on 26.10.2024.
//

import SwiftUI

struct ContentView: View {
    var myBlue = Color(red: 0.7490196078431373,
                       green: 0.8705882352941177,
                       blue: 0.9372549019607843)
    
    var myLiteViolet = Color(red: 0.9098039215686274,
                             green: 0.7490196078431373,
                             blue: 0.9372549019607843)
    
    var myYellow = Color(red: 0.9764705882352941,
                         green: 0.9294117647058824,
                         blue: 0.6745098039215687)
    
    var myGreen = Color(red: 0.6705882352941176,
                        green: 0.9764705882352941,
                        blue: 0.7372549019607844)
    
    var myGray = Color(red: 0.9490196078431372,
                       green: 0.9490196078431372,
                       blue: 0.9490196078431372)
    
    @State private var items: [CoverflowItem]
    
    init() {
        _items = State(initialValue: [
            CoverflowItem(title: "Не начато", color: myBlue),
            CoverflowItem(title: "В процессе", color: myLiteViolet),
            CoverflowItem(title: "Проверка", color: myYellow),
            CoverflowItem(title: "Завершен", color: myGreen)
        ])
    }

    @State private var spacing: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 0)
                
                CoverflowView(
                    itemWidth: 350,
                    spacing: 50,
                    items: items) { item in
                        VStack(alignment: .leading) {
                            VStack {
                                HStack {
                                    HStack {
                                        Text(item.title)
                                            .font(.title)
                                    }
                                    .bold()
                                    .padding()
                                    .frame(width: 200, height: 50, alignment: .leading)
                                    .background(item.color)
                                    .cornerRadius(15)
                                    
                                    .padding(.leading, 15)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                        .foregroundColor(.gray)
                                        
                                        .padding(.trailing, 15)
                                }
                            }
                            .frame(width: 350, height: 75)
                            .background(Color(myGray))
                            .cornerRadius(15)
                            
                            Spacer()
                        }
                        .frame(width: 350, height: 600)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        )
                }
                .frame(height: 600)
                
                Spacer(minLength: 0)
            }
            .navigationTitle("Cover Flow")
        }
    }
}

#Preview {
    ContentView()
}
