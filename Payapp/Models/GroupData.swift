//
//  GroupName.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI
import Firebase


struct GroupData: Identifiable , Hashable , Codable{
    
    var groupName: String
    var groupCode : String
    var Leader : [String : String]
    var AccountMemberList : [String : String] //アカウントのメンバー
    
    var MemberList : [ClubMember]
    var PayList : [PayItem]
    
    var id = UUID()
    
    init(groupName: String, groupCode: String = "", Leader: [String : String], AccountMemberList: [String : String] ,
         MemberList :[ClubMember] , PayList:[PayItem]) {
        self.groupName = groupName
        self.groupCode = groupCode
        self.Leader = Leader
        self.AccountMemberList = AccountMemberList
        self.MemberList = MemberList
        self.PayList = PayList
    }
    
    static func == (lhs: GroupData, rhs: GroupData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Firestore へ追加
    mutating func groupFireAdd() {
            
        let db = Firestore.firestore()
            
        let groupData: [String: Any] = [
            "groupName": self.groupName,
            "groupCode": self.groupCode,
            "Leader": self.Leader,
            "AccountMemberList": self.AccountMemberList,
            "MemberList" : self.MemberList,
            "PayList" : self.PayList
        ]
            
            
        // ドキュメントIDは groupCode を使う例（任意）
        db.collection("Group").document(self.groupCode).setData(groupData) { error in
            if let error = error {
                print("グループ追加失敗: \(error)")
            } else {
                print("グループ追加に成功しました。")
            }
        }
    }
        
    // Firestore のデータを更新
    func groupFireChange() {
        let db = Firestore.firestore()
        let changeRef = db.collection("Group").document(self.groupCode)
        
        let groupData: [String: Any] = [
            "groupName": self.groupName,
            "groupCode": self.groupCode,
            "Leader": self.Leader,
            "AccountMemberList": self.AccountMemberList,
            "MemberList" : self.MemberList,
            "PayList" : self.PayList
        ]
            
        changeRef.updateData(groupData) { error in
            if let error = error {
                print("グループ更新失敗: \(error)")
            } else {
                print("グループ更新に成功しました。")
            }
        }
    }
        
}
