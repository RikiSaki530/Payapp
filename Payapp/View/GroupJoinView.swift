//
//  GroupJoinView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループに所属する画面
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct GroupJoinView: View {
    
    @ObservedObject var user : User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ
    
    @State private var shouldNavigate = false
    @State private var groupCode : String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    
    
    var body: some View {
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループの参加コード", text: $groupCode)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                
                Button{
                    // ボタンを押した時、isCodeValidがtrueの場合に処理を実行
                    if !groupCode.isEmpty {
                        checkGroupExists(code: groupCode) { exists in
                            if exists {
                                fetchGroupData {
                                    shouldNavigate = true
                                }
                            } else {
                                alertMessage = "グループコードが間違っています。ご確認ください。"
                                showAlert = true
                            }
                        }
                    } else {
                        alertMessage = "コードを入力してください"
                        showAlert = true
                    }
                } label: {
                    Text("グループに参加")
                    
                        .foregroundColor(.black)
                        .frame(width: 150 , height: 50)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("エラー"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                }
            }
            .navigationDestination(isPresented: $shouldNavigate){
                ContentView(user:user , group: group)
                    .environmentObject(Memberdata)
                    .environmentObject(listData)
            }
        }
    }
    
    
    // Firestoreからグループデータを取得してstateのgroupに上書きする
    func fetchGroupData(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        // groupCodeを使ってFirestoreからグループ情報を取得
        db.collection("Group").document(groupCode).getDocument {
            (document, error) in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("ドキュメントが存在しないかデータが空です。")
                completion()
                return
            }
            
            print("Firestoreから取得したデータ: \(data)")
            
            // 基本情報のセット（これは非同期じゃなくてもOK）
            group.groupName = data["groupName"] as? String ?? ""
            group.groupCode = data["groupCode"] as? String ?? ""
            group.Leader = data["Leader"] as? [String: String] ?? [:]
            group.AccountMemberList = data["AccountMemberList"] as? [String: String] ?? [:]
            
            // メンバーリストのデコード
            if let memberArray = data["MemberList"] as? [[String: Any]] {
                print(memberArray)
                group.MemberList = memberArray.compactMap { dictionary in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
                        let member = try JSONDecoder().decode(ClubMember.self, from: jsonData)
                        return member
                    } catch {
                        print("ClubMemberのデコード失敗: \(error)")
                        return nil
                    }
                }
            } else {
                group.MemberList = []
            }
            
            // PayListのデコード
            if let payArray = data["PayList"] as? [[String: Any]] {
                print(payArray)
                group.PayList = payArray.compactMap { dictionary in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
                        let payItem = try JSONDecoder().decode(PayItem.self, from: jsonData)
                        return payItem
                    } catch {
                        print("PayItemのデコード失敗: \(error)")
                        return nil
                    }
                }
            } else {
                group.PayList = []
            }
            
            print("チェック用")
            print(group.MemberList)
            print(group.PayList)
            // グループのメンバーリストにユーザーを追加
            self.group.AccountMemberList[user.name] = user.UserID
            
            // ユーザーのグループリストに追加
            user.groupList[group.groupName] = group.groupCode
            user.admin[group.groupCode] = false
            //参加者として管理者権限はfalseに設定
            
            // ユーザー情報はFirestoreに更新する
            user.fireadd()// ユーザーのgroupListを更新
            
            for updatedMember in group.MemberList {
                if let index = Memberdata.members.firstIndex(where: { $0.id == updatedMember.id }) {
                    Memberdata.members[index] = updatedMember  // ✅内容だけ更新
                }
            }
            
            for updatedPay in group.PayList {
                if let index = listData.paylistitem.firstIndex(where: { $0.id == updatedPay.id }) {
                    listData.paylistitem[index] = updatedPay  // ✅ 内容だけ更新
                }
            }

            
            print(group.MemberList)
            print(group.PayList)
            
            Memberdata.members = group.MemberList
            listData.paylistitem = group.PayList
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    
    func checkGroupExists(code: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Group").document(code).getDocument { document, error in
            if let error = error {
                print("エラー: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    
}



