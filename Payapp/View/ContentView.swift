//
//  ContentView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct ContentView: View {
    
    @ObservedObject var user :User
    @ObservedObject var group : GroupData
    
    @EnvironmentObject var listData : PayList
    @EnvironmentObject var Memberdata : MemberList
    
    
    
    
    var body: some View {
        
        NavigationStack {
            
            Text(group.groupName)
                .font(.largeTitle)
            
            List {
                // 名前から誰が何を払ったかがわかるようにする
                NavigationLink("メンバー") {
                    MemberView(user: user , group: group) // MemberViewへデータを渡す
                        .navigationTitle("メンバー")
                        .environmentObject(Memberdata) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
                //支払いするものについて誰が払った払ってないをlist化
                NavigationLink("払うものリスト"){
                    MastPayView(user: user , group: group)
                        .navigationTitle("払うもののリスト")
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                    
                }
                //未払いのみをピックアップして誰が何を払っていないのかを把握
                NavigationLink("未払いリスト"){
                    UnpaidView(user: user , group: group)
                        .navigationTitle("未払いリスト")
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                }
                
                Section("追加"){
                    
                    NavigationLink("メンバー追加"){
                        MemberAddView(group : group)
                            .navigationTitle("メンバー追加")
                            .environmentObject(Memberdata)
                            .environmentObject(listData)
                    }
                    
                    NavigationLink("払うもの追加"){
                        PayListaddView(group : group)
                            .navigationTitle("払うもの追加")
                            .environmentObject(listData)
                            .environmentObject(Memberdata)
                    }
                    
                }
                
                Section{
                    NavigationLink("設定"){
                        SettingView(user : user)
                    }
                }
                
                Section{
                    NavigationLink("使い方"){
                        HintView()
                    }
                }
                
                //ここで管理者もしくはリーダーかを判断して権限追加する
                if user.admin[group.groupCode] == true || user.UserID == group.Leader[user.name]{
                    Section("管理用") {
                        NavigationLink("管理者を追加") {
                            AddminView(user: user, group: group)
                        }
                    }
                }

            }
        }
        
        .toolbar{
            ToolbarItem{
                ShareLink(item: "このグループに参加してね！コード: \(group.groupCode)" ){
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
        .onAppear{
            fetchOnlyMemberAndPayList {
                print("完了")
            }
            
        }
    }
    

    
    func fetchOnlyMemberAndPayList(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Group").document(group.groupCode).getDocument { (document, error) in
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
            
            
            // ローカルデータへの反映
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


            print("更新できたよ")
            

            DispatchQueue.main.async {
                completion()
            }
        }
    }

}
    

