//
//  AccountDeleteView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/29.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AccountDeleteView: View {
    
    @ObservedObject var user :User
    @ObservedObject var group : GroupData
    
    
    @State private var shouldloginView = false
    
    @State private var delteAlert = false
    @State private var deleteAlertMessage : String = ""
    
    @State private var showConfirmAlert = false
    
    @State private var deleteAccountMemberList : [String: String] = [:]
    @State private var checkLeader : [String: String] = [:]
    @State private var cannotdeletegroup : [String : String] = [:]
    @State private var groupname : String = ""
    @State private var password : String = ""
    @State private var reauthErrorMessage: String = ""
    
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack{
            
            //ここ,デザイン考えて
            Text("アカウントを完全に削除します")
                .foregroundColor(.red)
                .font(.title2)
            Text("削除後は元に戻せません。")
                .foregroundColor(.red)
                .font(.title3)
            Text("本当によろしいですか？")
                .foregroundColor(.red)
                .font(.title3)
            
            Spacer()
                .frame(height : 40)
            
            SecureField("パスワードを入力" , text: $password)
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            
            Button("OK") {
                if password.isEmpty {
                    reauthErrorMessage = "パスワードを入力してください。"
                } else {
                    showConfirmAlert = true
                    reauthErrorMessage = ""  // エラーメッセージをクリア
                }
            }
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
            .foregroundColor(.black)
            .alert("本当に削除しますか？", isPresented: $showConfirmAlert) {
                Button("キャンセル", role: .cancel) { }
                Button("削除", role: .destructive) {
                    acountDelete(password: password) { }
                }
            }
            
            
            Group {
                if !deleteAlertMessage.isEmpty {
                    VStack(spacing: 4) {
                        Text(deleteAlertMessage)
                        
                        Spacer()
                            .frame(height: 32)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(cannotdeletegroup.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                Text(key)
                            }
                            
                            .padding(.horizontal)  // 好みで調整可
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                } else if !reauthErrorMessage.isEmpty {
                    Text(reauthErrorMessage)
                        .foregroundColor(.red)
                } else {
                    // どちらも空なら高さを保つ透明なスペース
                    Text(" ")
                        .frame(height: 20)
                        .opacity(0)
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("ログアウト成功")
            
            user.reset()
            group.reset()
            
            UserDefaults.standard.removeObject(forKey: "userID")
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userName")
            
        } catch let error {
            print("ログアウト失敗: \(error.localizedDescription)")
        }
    }
    
    
    //これを用いればデリートできるようにしたい
    func acountDelete(password: String, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for groupcode in user.groupList.values {
            dispatchGroup.enter()
            allgroupDelete(groupcode: groupcode) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if cannotdeletegroup.isEmpty {
                let db = Firestore.firestore()
                db.collection("User").document(user.UserID).delete { error in
                    if let error = error {
                        print("Firestoreのユーザーデータ削除失敗: \(error)")
                        completion()
                        return
                    }
                    
                    // Firestoreの削除が終わってから再認証・削除を行う
                    reauthenticateAndDeleteUser(email: user.Mailaddress, password: password) { success in
                        if success {
                            print("アカウントが正常に削除されました")
                            logout()
                            path = NavigationPath()
                        } else {
                            print("再認証または削除に失敗しました")
                        }
                        completion()
                    }
                }
                
            } else {
                delteAlert = true
                deleteAlertMessage = "アカウントを消すには、以下のグループの管理者権限を他の人に渡すか、グループを削除する必要があります。"
                deletgroupList(grouplist: cannotdeletegroup){
                    completion()
                }
            }
        }
    }
    
    
    func allgroupDelete(groupcode : String , completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Group").document(groupcode).getDocument { (document, error) in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("ドキュメントが存在しないかデータが空です。")
                completion()
                return
            }
            
            //それぞれのgroupのアカウントメンバーリストを持ってくる
            deleteAccountMemberList = data["AccountMemberList"] as? [String:String] ?? [:]
            checkLeader = data["Leader"] as? [String: String] ?? [:]
            groupname = data["groupName"] as? String ?? ""
            
                
            
            let isLeader = checkLeader[user.name] == user.UserID
            let isOnlyMember = deleteAccountMemberList.count == 1
            
            if !isLeader || isOnlyMember {
                if isOnlyMember {
                    // グループごと削除
                    db.collection("Group").document(groupcode).delete { error in
                        if let error = error {
                            print("Firestoreのグループ削除失敗: \(error)")
                        } else {
                            print("Firestoreのグループ削除成功")
                        }
                        // ここでcompletionを呼ぶ
                        completion()
                    }
                    // これ以降の処理は不要なのでreturn
                    return
                } else {
                    // メンバーリストから削除して更新
                    deleteAccountMemberList.removeValue(forKey: user.name)
                    let docRef = db.collection("Group").document(groupcode)
                    docRef.updateData([
                        "AccountMemberList": deleteAccountMemberList
                    ]) { error in
                        if let error = error {
                            print("AccountMemberListの更新失敗: \(error.localizedDescription)")
                        } else {
                            print("AccountMemberListの更新成功")
                        }
                        completion()
                    }
                }
            } else {
                cannotdeletegroup[groupname] = groupcode
                completion()
            }
        }
    
    }
    
    func deletgroupList(grouplist : [String : String] , completion: @escaping () -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("User").document(user.UserID)
        
        docRef.updateData([
            "groupList": grouplist
        ]) { error in
            if let error = error {
                print("groupListの更新失敗: \(error.localizedDescription)")
            } else {
                print("groupListの更新成功")
            }
            completion()
        }
        
    }
    
    
    func reauthenticateAndDeleteUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            reauthErrorMessage = "現在ログインしているユーザーが見つかりません。"
            completion(false)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                print("再認証エラー: \(error.localizedDescription)")
                reauthErrorMessage = "再認証に失敗しました。パスワードを確認してください。"
                completion(false)
                return
            }
            
            user.delete { error in
                if let error = error {
                    print("ユーザー削除失敗: \(error.localizedDescription)")
                    reauthErrorMessage = "ユーザー削除に失敗しました。もう一度お試しください。"
                    completion(false)
                } else {
                    print("ユーザー削除成功")
                    completion(true)
                }
            }
        }
    }

}
