//
//  user.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//

//User設定を作りたい
//これでログインできるようにする

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class User: ObservableObject, Identifiable , Hashable{
    
    @Published var name: String
    @Published var Mailaddress: String
    @Published var admin: [String: Bool]
    @Published var groupList: [String : String]
    @Published var UserID: String
    
    var id = UUID()
    
    init(name: String, Mailaddress: String, admin: [String: Bool], groupList: [String : String], UserID: String) {
        self.name = name
        self.Mailaddress = Mailaddress
        self.admin = admin
        self.groupList = groupList
        self.UserID = UserID
    }
    
    func fireadd(){
        let db = Firestore.firestore()
        let changeRef = db.collection("User").document(self.UserID)
        
        let userData: [String: Any] = [
            "name": self.name,
            "Mailaddress": self.Mailaddress,
            "admin": self.admin,
            "groupList": self.groupList,
            "UserID": self.UserID
        ]

        changeRef.setData(userData) { error in
            if let error = error {
                print("❌ データ更新失敗: \(error)")
            } else {
                print("✅ データ更新に成功しました。")
            }
        }
    }
    
    func reset() {
        self.name = ""
        self.Mailaddress = ""
        self.admin = [:]
        groupList = [:]
        UserID = ""
    }
    
    //ハッシュ化
    // MARK: - Equatable
        static func == (lhs: User, rhs: User) -> Bool {
            return lhs.UserID == rhs.UserID
        }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(UserID)
    }
    
}


