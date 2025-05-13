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
                NavigationLink("名前") {
                    MemberView(user: user , group: group) // MemberViewへデータを渡す
                        .navigationTitle("Members")
                        .environmentObject(Memberdata) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
                //支払いするものについて誰が払った払ってないをlist化
                NavigationLink("支払い項目"){
                    MastPayView(user: user , group: group)
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                    
                }
                //未払いのみをピックアップして誰が何を払っていないのかを把握
                NavigationLink("未払いリスト"){
                    UnpaidView(user: user , group: group)
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                }
                
                Section("追加"){
                    
                    NavigationLink("メンバー追加"){
                        MemberAddView(group : group)
                            .environmentObject(Memberdata)
                            .environmentObject(listData)
                    }
                    
                    NavigationLink("支払い項目追加"){
                        PayListaddView(group : group)
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
                    NavigationLink("Hint"){
                        HintView()
                    }
                }
                
                if user.admin[group.groupCode] == true {
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
            memberfireadd()
            paylistfireadd()
        }
    }
    
    func memberfireadd(){
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Mdata = Memberdata.members.map { $0.toDictionary() }

        docRef.updateData([
            "MemberList": Mdata
        ]){ error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("contentView:データを更新しました")
            }
        }
    }
    
    func paylistfireadd() {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Pdata = listData.paylistitem.map{ $0.toDictionary() }
        
        docRef.updateData([
                "PayList": Pdata
        ]) { error in
                if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("contentView:データを更新しました")
            }
        }
    }
}
    

