//
//  NameSettingView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NameSettingView: View {
    
    @ObservedObject var newUser : User
    @State private var shouldNavigate = false  // 遷移フラグ
    @State private var errorMessage: String?   // エラーメッセージ用
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing: 30){
                
                TextField("名前を入力" , text: $newUser.name)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("OK") {
                    if newUser.name.isEmpty {
                        // 名前が入力されていない場合はエラーメッセージを表示
                        errorMessage = "名前を入力してください。"
                    } else {
                        checkUserExistence()  // ユーザー存在確認
                        shouldNavigate = true
                    }
                }
                .foregroundColor(.black)
                .frame(width: 75, height: 50)
                .background(Color.yellow)
                .cornerRadius(10)
                
                // エラーメッセージがあれば表示
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            // 遷移先のView
            // navigationDestination は NavigationStack 内で使用されるべき
            .navigationDestination(isPresented: $shouldNavigate) {
                GroupListView(existingUser: newUser)
            }
        }
    }
    
    
    func checkUserExistence() {
        
        let db = Firestore.firestore()
        
        // Firestoreからuserの存在を確認
        db.collection("User").document(newUser.UserID).getDocument { document, error in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorMessage = "エラーが発生しました。再度試してください。"
                }
                return
            }
            
            newUser.fireadd()
            
        }
    }
}

