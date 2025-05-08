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

class User: ObservableObject, Identifiable {
    
    @Published var name: String
    @Published var Mailaddress: String
    @Published var Password: String
    @Published var admin: [String: Bool]
    @Published var groupList: [String : String]
    @Published var UserID: String
    
    var id = UUID()
    
    init(name: String, Mailaddress: String, Password: String, admin: [String: Bool], groupList: [String : String], UserID: String) {
        self.name = name
        self.Mailaddress = Mailaddress
        self.Password = Password
        self.admin = admin
        self.groupList = groupList
        self.UserID = UserID
    }
    
    // Firestore にユーザー新規追加
    func userfireadd() {
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "name": self.name,
            "Mailaddress": self.Mailaddress,
            "Password": self.Password,
            "admin": self.admin,
            "UserID": self.UserID,
            "groupList": self.groupList
        ]
        
        db.collection("User").document(self.UserID).setData(userData) { error in
            if let error = error {
                print("❌ データ追加失敗: \(error)")
            } else {
                print("✅ データ追加に成功しました。")
            }
        }
    }
    
    // Firestore 上のユーザー情報を更新
    func userfirechange() {
        let db = Firestore.firestore()
        let changeRef = db.collection("User").document(self.UserID)
        
        let userData: [String: Any] = [
            "name": self.name,
            "Mailaddress": self.Mailaddress,
            "Password": self.Password,
            "admin": self.admin,
            "UserID": self.UserID,
            "groupList": self.groupList
        ]
        
        changeRef.updateData(userData) { error in
            if let error = error {
                print("❌ データ更新失敗: \(error)")
            } else {
                print("✅ データ更新に成功しました。")
            }
        }
    }
}


