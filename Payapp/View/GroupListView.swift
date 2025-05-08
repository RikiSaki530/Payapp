//
//  GroupListView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI
import FirebaseFirestore

struct GroupListView: View {
    
    @ObservedObject var existingUser :User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ
    
    @State private var selectedGroup: GroupData? = nil
    @State private var selectedGroupCode: String? = nil
    @State private var isActive = false
    
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing: 20){
                
                Spacer()
                    .frame(height : 25) // ← 幅を指定
                
                NavigationLink("グループを作成") {
                    GroupCreationView(user: existingUser)
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 60)
                .background(Color.green)
                .cornerRadius(15)
                
                NavigationLink("グループに参加"){
                    GroupJoinView(user: existingUser)
                }
                .foregroundColor(.black) // ← テキストの色も明示
                .frame(width: 300 , height: 60)
                .background(Color.mint)
                .cornerRadius(15)
                
                
                ForEach(Array(existingUser.groupList), id: \.key) { key, value in
                    Button {
                        selectedGroupCode = value
                        fetchGroupData(groupcode: value) {
                            isActive = true
                        }
                    } label: {
                        Text(key)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 60)
                            .background(Color.mint)
                            .cornerRadius(15)
                    }
                }
                
                Spacer()
            }
            
            .navigationDestination(isPresented: $isActive) {
                ContentView(user: existingUser, group: $group)
                    .environmentObject(listData)
                    .environmentObject(Memberdata)
            }
        }
    }
    
    // Firestoreからグループデータを取得してstateのgroupに上書きする
    func fetchGroupData(groupcode : String , completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        // groupCodeを使ってFirestoreからグループ情報を取得
        db.collection("Group").document(groupcode).getDocument {
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
                self.group.AccountMemberList[existingUser.name] = existingUser.UserID
                self.group.Leader[existingUser.name] = existingUser.UserID
                
                // ユーザーのグループリストに追加
                existingUser.groupList[group.groupName] = group.groupCode
                if existingUser.admin[group.groupCode] != true {
                    existingUser.admin[group.groupCode] = false
                }
                //参加者として管理者権限はfalseに設定
                
                // ユーザー情報もFirestoreに更新する
                existingUser.userfirechange()  // ユーザーのgroupListを更新
                group.groupFireChange() // グループのMemberListを更新
                
                completion()
            } else {
                print("指定したグループは存在しません")
            }
        }
    }
}
