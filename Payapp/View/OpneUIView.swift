//
//  Untitled 2.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

//入ってきて一番最初の画面
import SwiftUI

struct OpneUIView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("会計app")
                    .font(.largeTitle)
                
                Spacer()
                    .frame(height : 64)
                    
                NavigationLink(destination: SingUpView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.yellow)
                            .frame(width: 200, height: 60)
                        
                        Text("新規登録")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                
                Spacer()
                    .frame(height: 32)
                
                NavigationLink(destination: LoginView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.yellow)
                            .frame(width: 200, height: 60)
                        
                        Text("ログイン")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                
                .padding()
            }
        }
    }
}
