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
    
    @Binding var user : User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ
    
    @State private var shouldNavigate = false
    
    
    var body: some View {
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループの参加コード", text: $group.groupCode)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                
                Button("参加") {
                    // ボタンを押した時、isCodeValidがtrueの場合に処理を実行
                    if !group.groupCode.isEmpty {
                        fetchGroupData() // グループデータのフェッチ
                        shouldNavigate = true
                    }
                }
                .frame(width: 300, height: 60)
                .background(Color.green) // 入力が有効な場合は緑
                .cornerRadius(15)
                .foregroundColor(.black)
                       
            }
            .navigationDestination(isPresented: $shouldNavigate){
                ContentView(user:$user , group: $group)
                    .environmentObject(Memberdata)
                    .environmentObject(listData)
            }
        }
    }
    
        
    // Firestoreからグループデータを取得してstateのgroupに上書きする
    func fetchGroupData() {
        let db = Firestore.firestore()
        
        // groupCodeを使ってFirestoreからグループ情報を取得
        db.collection("Group").document(group.groupCode).getDocument {
            (document, error) in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                
                // Firestoreから取得したデータをGroupDataに変換して上書き
                self.group = GroupData(
                    groupName: data?["groupName"] as? String ?? "",
                    groupCode: data?["groupCode"] as? String ?? "",
                    Leader: data?["Leader"] as? [String: String] ?? [:],
                    AccountMemberList: data?["AccountMemberList"] as? [String:String] ?? [:],
                    MemberList: data?["MemberList"] as? [ClubMember] ?? [],
                    PayList : data?["PayList"] as? [PayItem] ?? []
                )
                
                // グループのメンバーリストにユーザーを追加
                self.group.AccountMemberList[user.name] = user.UserID
                self.group.Leader[user.name] = user.UserID
                
                // ユーザーのグループリストに追加
                user.groupList.append(group)
                user.admin[group.groupCode] = false
                //参加者として管理者権限はfalseに設定
                
                // ユーザー情報もFirestoreに更新する
                user.userfirechange()  // ユーザーのgroupListを更新
                group.groupFireChange() // グループのMemberListを更新
                
            } else {
                print("指定したグループは存在しません")
            }
        }
    }
}



