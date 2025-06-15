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
    
    @Binding var path: NavigationPath
    
    @ObservedObject var newUser : User
    @State private var errorMessage: String?   // エラーメッセージ用
    
    var body: some View {
        
        VStack(spacing: 30){
            
            TextField("ユーザー名を入力" , text: $newUser.name)
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Button("OK") {
                if newUser.name.isEmpty {
                    // 名前が入力されていない場合はエラーメッセージを表示
                    errorMessage = "名前を入力してください。"
                } else {
                    checkUserExistence {
                        path.append(Destination.GroupList(existingUser: newUser))
                    }
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
        .navigationBarBackButtonHidden(true)
    }
    
    
    func checkUserExistence(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("User").document(newUser.UserID).getDocument { document, error in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorMessage = "エラーが発生しました。再度試してください。"
                    completion()
                }
                return
            }
            
            newUser.fireadd()
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }

}

