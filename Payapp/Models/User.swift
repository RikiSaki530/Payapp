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
    var admin : Bool //管理者権限を与える
    var leader : Bool  //グループに入っている人の権限をいじれる
    var groupList : [ GroupData ] = []
    var UserID : Int
    
    var id = UUID()
}
