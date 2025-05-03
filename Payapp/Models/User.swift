//
//  user.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//

//User設定を作りたい
//これでログインできるようにする

import SwiftUI

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
}
