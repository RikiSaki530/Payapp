//
//  FirstExplanationView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/26.
//
import SwiftUI

struct FirstExplanationView: View {
    var body: some View {
        NavigationStack{
            
            VStack{
                
                Text("FirstExplanationView")
                
                NavigationLink("Next") {
                    OpneUIView()
                }
                .frame(width: 300, height: 60)
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
                .font(.title2)
            }
        }
    }
}
