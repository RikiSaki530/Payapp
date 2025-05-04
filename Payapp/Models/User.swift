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

struct User : Identifiable{

    var name : String
    var Mailaddress : String
    var Password : String
    var admin : [String : Bool] //管理者権限を与える
    var groupList : [ GroupData ] = []
    var UserID : Int
    
    var id = UUID()
    
    init(name: String, Mailaddress: String, Password: String, admin: [String : Bool], groupList: [GroupData], UserID: Int) {
        self.name = name
        self.Mailaddress = Mailaddress
        self.Password = Password
        self.admin = admin
        self.groupList = groupList
        self.UserID = UserID
    }

    
    //作成
    func userfireadd() {
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "name": self.name,
            "Mailaddress": self.Mailaddress,
            "Password": self.Password,
            "admin": self.admin,
            "UserID": self.UserID,
            "groupList": self.groupList.map { $0.toDict() }
        ]
        
        db.collection("User").document(String(self.UserID)).setData(userData) { error in
            if let error = error {
                print("データ追加失敗: \(error)")
            } else {
                print("データ追加に成功しました。")
            }
        }
    }
    
    //変更
    func userfirechange() {
        
        let db = Firestore.firestore()
        let changeRef = db.collection("User").document(String(self.UserID))
        
        let userData: [String: Any] = [
                "name": self.name,
                "Mailaddress": self.Mailaddress,
                "Password": self.Password,
                "admin": self.admin,
                "UserID": self.UserID,
                "groupList": self.groupList.map { $0.toDict() }
            ]
            
        changeRef.updateData(userData) { error in
            if let error = error {
                print("データ更新失敗: \(error)")
            } else {
                print("データ更新に成功しました。")
            }
        }
    }
    

    
}

extension GroupData {
    func toDict() -> [String: Any] {
        return [
            "groupName": groupName,
            "groupCode": groupCode,
            "Leader": Leader,
            "MemberList": MemberList
        ]
    }
}
