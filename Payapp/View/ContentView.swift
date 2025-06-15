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
    
    @Binding var path: NavigationPath
    
    var body: some View {
        
        ZStack{
            Color.gray.opacity(0.13)  // 好きな色
                    .ignoresSafeArea() // 画面の安全領域も無視して全面に表示

            
            VStack(spacing: 20){
                
                Text(group.groupName)
                    .font(.largeTitle)
                    .frame(height: 50)
                
                // 名前から誰が何を払ったかがわかるようにする
                NavigationLink(value:Destination.Member(user: user, group: group)) {
                    Text("メンバー")
                        .foregroundColor(.black)
                        .frame(width: 300, height: 60)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.cyan, lineWidth: 4)  // ここで黒い枠をつける
                        )
                        .contentShape(Rectangle())
                }
                
                Text("お金のかんり")
                    .font(.title2)
                
                HStack{
                    //支払いするものについて誰が払った払ってないをlist化
                    NavigationLink(value : Destination.MastPay(user: user, group: group)){
                        Text("払うものリスト")
                            .foregroundColor(.black)
                            .frame(width: 125, height: 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.orange, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                        
                    }
                    
                    Spacer()
                        .frame(width: 50)
                    
                    //未払いのみをピックアップして誰が何を払っていないのかを把握
                    NavigationLink(value:Destination.Unpaid(user: user, group: group)){
                        Text("未払いリスト")
                            .foregroundColor(.black)
                            .frame(width: 125, height:60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.orange, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                    }
                }
                
                Text("追加")
                    .font(.title2)
                
                HStack{
                    NavigationLink(value:Destination.MemberAdd(group: group)){
                        Text("メンバー追加")
                            .foregroundColor(.black)
                            .frame(width: 125, height: 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.yellow, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                        .frame(width: 50)
                    
                    NavigationLink(value:Destination.PayListAdd(group: group)){
                        Text("払うもの追加")
                            .foregroundColor(.black)
                            .frame(width: 125, height: 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.yellow, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                    }
                }
                
                Text("オプション")
                    .font(.title2)
                
                HStack{
                    NavigationLink(value: Destination.Setting(user: user, group: group)) {
                        Text("設定")
                            .foregroundColor(.black)
                            .frame(width: 125, height: 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.mint, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                        .frame(width: 50)
                    
                    NavigationLink(value:Destination.Hint){
                        Text("使い方")
                            .foregroundColor(.black)
                            .frame(width: 125, height: 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.mint, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                    }
                }
                
                
                //ここで管理者もしくはリーダーかを判断して権限追加する
                if user.admin[group.groupCode] == true || user.UserID == group.Leader[user.name]{
                    
                    NavigationLink(value : Destination.Addmin(user: user, group: group)) {
                        Text("管理者を設定")
                            .foregroundColor(.black)
                            .frame(width: 300, height: 60)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 4)  // ここで黒い枠をつける
                            )
                            .contentShape(Rectangle())
                    }
                }
                Spacer()
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
            updateAccountMemberList()
            
        }
    }
    

    //他の要素も置き換えた方が良くない？
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

    func updateAccountMemberList() {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        
        docRef.updateData([
            "AccountMemberList.\(user.name)": user.UserID
        ]) { error in
            if let error = error {
                print("AccountMemberListの更新失敗: \(error.localizedDescription)")
            } else {
                print("AccountMemberListの更新成功")
            }
        }
    }
    
}
    

