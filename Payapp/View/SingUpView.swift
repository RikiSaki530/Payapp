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
    
    @Binding var path: NavigationPath
    
    @StateObject var newUser = User(name: "", Mailaddress: "", admin: [:], groupList: [:], UserID: "")
    @State private var errorMessage = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            
            TextField("メールアドレス", text: $newUser.Mailaddress)
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
            
            SecureField("パスワード", text: $password)
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Button("OK") {
                register(
                    name: newUser.name,
                    email: newUser.Mailaddress,
                    password: password,
                    completion: { createdUser in
                        if let createdUser = createdUser {
                            newUser.name = createdUser.name
                            newUser.Mailaddress = createdUser.Mailaddress
                            newUser.UserID = createdUser.UserID
                            
                            path.append(Destination.NameSetting(newUser: newUser))
                            
                            UserDefaults.standard.set(newUser.UserID, forKey: "userID")
                            UserDefaults.standard.set(newUser.Mailaddress, forKey: "userEmail")
                            UserDefaults.standard.set(newUser.name, forKey: "userName")
                            UserDefaults.standard.synchronize()
                        }
                    },
                    onError: { message in
                        errorMessage = message
                    }
                )
            }
            .foregroundColor(.black)
            .frame(width: 75, height: 45)
            .background(Color.yellow)
            .cornerRadius(10)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
            }
        }
    }
    
    func register(
        name: String,
        email: String,
        password: String,
        completion: @escaping (User?) -> Void,
        onError: @escaping (String) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let message: String
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    message = "このメールアドレスは既に使用されています。"
                case .invalidEmail:
                    message = "メールアドレスの形式が正しくありません。"
                case .weakPassword:
                    message = "パスワードは6文字以上にしてください。"
                default:
                    message = "登録に失敗しました: \(error.localizedDescription)"
                }
                print("エラー内容: \(message)")
                onError(message)
                completion(nil)
                return
            }
            
            guard let authUser = authResult?.user else {
                onError("Firebaseユーザー情報が取得できませんでした。")
                completion(nil)
                return
            }
            
            let newUser = User(
                name: name,
                Mailaddress: email,
                admin: [:],
                groupList: [:],
                UserID: authUser.uid
            )
            
            completion(newUser)
        }
    }
}
