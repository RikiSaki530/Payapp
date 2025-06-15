//
//  UnpaidView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/28.
//

import SwiftUI
import FirebaseFirestore

struct UnpaidView: View {
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    @Binding var path: NavigationPath
    
    @EnvironmentObject var Memberdata: MemberList
    @EnvironmentObject var listData: PayList
    @State var unpaidlist: [String] = []
    
    var body: some View {
        
        List {
            // ForEachでunpaidListのアイテムを表示
            ForEach($unpaidlist, id: \.self) { $item in
                Section(
                    header: Text(item)
                        .font(.title3)
                ) {
                    // unpaidMemberを使って未払いのメンバーを表示
                    UnpaidlistView(item: $item, user :user , group: group)
                }
            }
        }
        .onAppear {
            fetchOnlyMemberAndPayList {
                unpaidList()  // `unpaidList`を初期化する
                print("データ復旧")
                
            }
        }
    }
    
    
    func unpaidList() {
        unpaidlist = []  // 念のため初期化

        for item in listData.paylistitem {
            for member in Memberdata.members {
                if let status = member.paymentStatus.first(where: { $0.name == item.name })?.paystatus,
                   status == "❌" {
                    unpaidlist.append(item.name)
                    break
                }
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

