//
//  GroupListView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct GroupListView: View {
    
    @ObservedObject var existingUser :User
    @StateObject var group = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    
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
                    GroupJoinView(user: existingUser )
                }
                .foregroundColor(.black) // ← テキストの色も明示
                .frame(width: 300 , height: 60)
                .background(Color.green)
                .cornerRadius(15)
                
                
                ForEach(Array(existingUser.groupList), id: \.key) { key, value in
                    Button {
                        print(value)
                        if !value.isEmpty {
                            selectedGroupCode = value
                            fetchGroupData(groupcode: value , group: group){
                                isActive = true
                            }
                        } else {
                            print("⚠️ groupCode が空です")
                        }
                    } label: {
                        Text(key)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 60)
                            .background(Color.yellow)
                            .cornerRadius(15)
                    }
                }
                
                Spacer()
            }
            
            .navigationDestination(isPresented: $isActive) {
                ContentView(user: existingUser, group: group )
                    .environmentObject(listData)
                    .environmentObject(Memberdata)
            }
        }
    }
    
    // Firestoreからグループデータを取得してstateのgroupに上書きする
    func fetchGroupData(groupcode: String, group: GroupData, completion: @escaping () -> Void) {
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
            
            Memberdata.members = group.MemberList
            listData.paylistitem = group.PayList
            
            // UI更新などはメインスレッドで
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
