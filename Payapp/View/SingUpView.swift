//
//  Untitled 3.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SingUpView: View {
    
    @StateObject var newUser = User(name: "", Mailaddress: "", Password: "", admin: [:], groupList: [:], UserID: "")
    @State private var isRegistered = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                TextField("メールアドレス", text: $newUser.Mailaddress)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                SecureField("パスワード", text: $newUser.Password)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("OK") {
                    register(
                        name: newUser.name,
                        email: newUser.Mailaddress,
                        password: newUser.Password
                    ) { createdUser in
                        if let createdUser = createdUser {
                            newUser.name = createdUser.name
                            newUser.Mailaddress = createdUser.Mailaddress
                            newUser.Password = createdUser.Password
                            newUser.UserID = createdUser.UserID
                            isRegistered = true
                        } else {
                            errorMessage = "登録に失敗しました"
                        }
                    }
                }
                .foregroundColor(.black)
                .frame(width: 75, height: 45)
                .background(Color.yellow)
                .cornerRadius(10)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            // ✅ VStack に navigationDestination を適用
            .navigationDestination(isPresented: $isRegistered) {
                NameSettingView(newUser: newUser) // 新しいユーザーを渡す
            }
        }
    }
    
    
    func register(name: String, email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("登録失敗: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let authUser = authResult?.user else {
                print("Firebaseユーザー情報が取得できませんでした。")
                completion(nil)
                return
            }
            
            let newUser = User(
                name: name,
                Mailaddress: email,
                Password: password,
                admin: [:],
                groupList: [:],
                UserID: authUser.uid
            )
            
            completion(newUser)
        }
    }
    
}
