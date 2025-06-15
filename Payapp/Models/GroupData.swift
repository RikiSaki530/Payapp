//
//  GroupName.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI
import FirebaseFirestore


class GroupData: Identifiable , ObservableObject ,Hashable {
    
    @Published var groupName: String
    @Published var groupCode : String
    @Published var Leader : [String : String]
    @Published var AccountMemberList : [String : String] //アカウントのメンバー
    @Published var Status : String
    
    @Published var MemberList : [ClubMember] = []
    @Published var PayList : [PayItem] = []
    
    
    @DocumentID var id: String?
    
    init(groupName: String, groupCode: String = "", Status : String ,Leader: [String : String], AccountMemberList: [String : String] ,
         MemberList :[ClubMember] , PayList:[PayItem]) {
        self.groupName = groupName
        self.groupCode = groupCode
        self.Status = Status
        self.Leader = Leader
        self.AccountMemberList = AccountMemberList
        self.MemberList = MemberList
        self.PayList = PayList
    }
            
    func fireadd() {
        let db = Firestore.firestore()
        let changeRef = db.collection("Group").document(self.groupCode)
        
        // GroupData のプロパティを辞書型に変換
        let groupData: [String: Any] = [
            "groupName": self.groupName,
            "groupCode": self.groupCode,
            "Leader": self.Leader,
            "Status": self.Status,
            "AccountMemberList": self.AccountMemberList,
            "MemberList": self.MemberList, // ClubMember の配列を辞書に変換
            "PayList": self.PayList // PayItem の配列を辞書に変換
        ]
        
        // Firestore に保存または更新
        changeRef.setData(groupData) { error in
            if let error = error {
                print("グループ情報更新エラー: \(error.localizedDescription)")
            } else {
                print("グループ情報更新成功")
            }
        }
    }
    
    func reset() {
        groupName = ""
        groupCode = ""
        Leader = [:]
        AccountMemberList = [:]
        MemberList = []
        PayList = []
    }
    
    // MARK: - Equatable
        static func == (lhs: GroupData, rhs: GroupData) -> Bool {
            return lhs.groupCode == rhs.groupCode
        }

        // MARK: - Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(groupCode)
        }
}


