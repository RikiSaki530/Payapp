//
//  LoginView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

//LoginView

struct LoginView: View {
    
    @StateObject var ExistingUser = User(name: "", Mailaddress: "", admin: [:],  groupList : [:], UserID: "")
    @State private var loginSuccess = false
    @State private var errorMessage: String?
    @State private var password : String = ""
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("メールアドレス" , text: $ExistingUser.Mailaddress)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                TextField("パスワード" , text: $password)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("ログイン") {
                    login(email: ExistingUser.Mailaddress, password: password) { user in
                        if let user = user {
                            self.loginSuccess = true
                            
                            // ✅ @StateObject の ExistingUser に代入
                            ExistingUser.name = user.name
                            ExistingUser.Mailaddress = user.Mailaddress
                            ExistingUser.admin = user.admin
                            ExistingUser.UserID = user.UserID
                            ExistingUser.groupList = user.groupList
                            //確認用
                            print(ExistingUser.name)
                            
                            print("UserDefaults saved")
                            // UserDefaults に保存
                            UserDefaults.standard.set(user.UserID, forKey: "userID")
                            UserDefaults.standard.set(user.Mailaddress, forKey: "userEmail")
                            UserDefaults.standard.set(user.name, forKey: "userName")
                            
                            
                            if let name = UserDefaults.standard.string(forKey: "userName") {
                                print("保存されたユーザー名: \(name)")
                            } else {
                                print("ユーザー名がUserDefaultsに保存されていません")
                            }
                            
                            
                        } else {
                            self.errorMessage = "ログインに失敗しました。メールアドレスまたはパスワードを確認してください。"
                        }
                        
                    }
                }
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .foregroundColor(.black)
                // エラーメッセージがあれば表示
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding()
            .navigationDestination(isPresented: $loginSuccess) {
                GroupListView(existingUser: ExistingUser)
            }
        }
    }
    
    
    func login(email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("ログイン失敗: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let authResult = authResult else {
                print("authResultがnilです")
                completion(nil)
                return
            }
            
            let firebaseUser = authResult.user
            print("ログイン成功: \(firebaseUser.email ?? "No Email")")
            
            // FirestoreからUserデータを取得
            let db = Firestore.firestore()
            db.collection("User").whereField("Mailaddress", isEqualTo: email).getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore取得失敗: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("ユーザーデータが見つかりません")
                    completion(nil)
                    return
                }
                
                let data = document.data()
                let fetchedUser = User(
                    name: data["name"] as? String ?? "",
                    Mailaddress: data["Mailaddress"] as? String ?? "",
                    admin: data["admin"] as? [String: Bool] ?? [:],
                    groupList: data["groupList"] as? [String: String] ?? [:],
                    UserID: data["UserID"] as? String ?? ""
                )
                
                DispatchQueue.main.async {
                    completion(fetchedUser)
                }
            }
        }
    }
    
}
    


