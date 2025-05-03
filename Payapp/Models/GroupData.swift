//
//  GroupName.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI
import Firebase


struct GroupData: Identifiable {
    
    var groupName: String
    var groupCode : String
    var Leader : [String : Int]
    var MemberList : [String : Int]
    
    var id = UUID()
    
    init(groupName: String, groupCode: String = "", Leader: [String : Int], MemberList: [String : Int]) {
        self.groupName = groupName
        self.groupCode = groupCode
        self.Leader = Leader
        self.MemberList = MemberList
    }
    
    
}
