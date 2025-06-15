//
//  IndividualView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore

struct IndividualView : View{
    
    @Binding var individual : ClubMember
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    @EnvironmentObject var Memberdata: MemberList // 親ビューから渡されたデータ
    
    var body: some View {
        VStack {
            Text("名前 : " + individual.name)
                .font(.title)
            
            if !individual.grade.isEmpty {
                if !group.Status.isEmpty {
                    Text(group.Status + " : " + individual.grade)
                        .font(.title)
                }else{
                    Text("学年 : " + individual.grade)
                        .font(.title)
                }
            }
            
            PaylistView(user: user, group: group, member: $individual)
                .environmentObject(Memberdata)
        }
        .onAppear {
            fetchOnlyMemberAndPayList {
                print("復元")
            }
            print(individual.name)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("編集") {
                    ChangeUserInfoView(group: group , individual : $individual )
                        .environmentObject(Memberdata)
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

            
            // ローカルデータへの反映
            for updatedMember in group.MemberList {
                if let index = Memberdata.members.firstIndex(where: { $0.id == updatedMember.id }) {
                    Memberdata.members[index] = updatedMember  // ✅内容だけ更新
                }
            }
            
            print("更新できたよ")
            

            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
