//
//  GroupListView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI
import FirebaseFirestore

struct GroupListView: View {
    
    @Binding var existingUser :User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ
    
    @State private var selectedGroup: GroupData? = nil
    
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing: 20){
                
                Spacer()
                    .frame(height : 25) // ← 幅を指定
                
                NavigationLink("グループを作成") {
                    GroupCreationView(user: $existingUser)
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 60)
                .background(Color.green)
                .cornerRadius(15)
                
                NavigationLink("グループに参加"){
                    GroupJoinView(user: $existingUser)
                }
                .foregroundColor(.black) // ← テキストの色も明示
                .frame(width: 300 , height: 60)
                .background(Color.mint)
                .cornerRadius(15)
                
                
                ForEach($existingUser.groupList){$group in
                    NavigationLink{
                        ContentView(user: $existingUser , group: $group)
                            .environmentObject(listData)
                            .environmentObject(Memberdata)
                    }label: {
                        Text(group.groupName)
                    }
                    .foregroundColor(.black) // ← テキストの色も明示
                    .frame(width: 300 , height: 60)
                    .background(Color.mint)
                    .cornerRadius(15)
                }
                
                Spacer()
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
                    Leader: data?["Leader"] as? [String: Int] ?? [:],
                    AccountMemberList: data?["AccountMemberList"] as? [String:Int] ?? [:],
                    MemberList: data?["MemberList"] as? [ClubMember] ?? [],
                    PayList : data?["PayList"] as? [PayItem] ?? []
                )
                
                // グループのメンバーリストにユーザーを追加
                self.group.AccountMemberList[existingUser.name] = existingUser.UserID
                self.group.Leader[existingUser.name] = existingUser.UserID
                
                // ユーザーのグループリストに追加
                existingUser.groupList.append(group)
                existingUser.admin[group.groupCode] = false
                //参加者として管理者権限はfalseに設定
                
                // ユーザー情報もFirestoreに更新する
                existingUser.userfirechange()  // ユーザーのgroupListを更新
                group.groupFireChange() // グループのMemberListを更新
                
            } else {
                print("指定したグループは存在しません")
            }
        }
    }
}




struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:], groupList : [], UserID: 0)
        
        GroupListView(existingUser: $newUser)
    }
}
