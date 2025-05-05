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
    
    @State var ExistingUser = User(name: "", Mailaddress: "", Password: "", admin: [:],  groupList : [], UserID: "")
    @State private var loginSuccess = false
    @State private var errorMessage: String?
    
    var body: some View {
        
        NavigationStack{
        
            VStack(spacing : 30){
                
                TextField("メールアドレス" , text: $ExistingUser.Mailaddress)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                TextField("パスワード" , text: $ExistingUser.Password)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("ログイン") {
                    login(email: ExistingUser.Mailaddress, password: ExistingUser.Password) { user in
                    if let user = user {
                        self.ExistingUser = user
                        self.loginSuccess = true
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
                GroupListView(existingUser: $ExistingUser)
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

        // GroupData配列に変換
            let groups = (data["groupList"] as? [[String: Any]] ?? []).compactMap { dict -> GroupData? in
                guard
                    let name = dict["groupName"] as? String,
                    let code = dict["groupCode"] as? String,
                    let leader = dict["Leader"] as? [String: String],
                    let accountMembers = dict["AccountMemberList"] as? [String: String],
                    let rawMemberList = dict["MemberList"] as? [ClubMember],
                    let rawPayList = dict["PayList"] as? [PayItem]
                else {
                    return nil
                }

                return GroupData(
                    groupName: name,
                    groupCode: code,
                    Leader: leader,
                    AccountMemberList: accountMembers,
                    MemberList: rawMemberList,
                    PayList: rawPayList
                )
            }

                    // User型を作成
                    let user = User(
                        name: data["name"] as? String ?? "",
                        Mailaddress: data["Mailaddress"] as? String ?? "",
                        Password: data["Password"] as? String ?? "",
                        admin: data["admin"] as? [String: Bool] ?? [:],
                        groupList: groups,
                        UserID: data["UserID"] as? String ?? ""
                    )

                    completion(user)
                }
            }
        }

}

struct LogicalView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
