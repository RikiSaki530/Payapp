//
//  AddminView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/03.
//

import SwiftUI
import FirebaseFirestore

struct AddminView: View {
    
    @ObservedObject var user: User
    @ObservedObject var group: GroupData
    
    @Binding var path: NavigationPath
    
    var body: some View {
        let members = group.AccountMemberList
            .sorted(by: { $0.key < $1.key })
            .map { MemberEntry(key: $0.key, value: $0.value) }
        
        return List {
            ForEach(members) { entry in
                AddminchangeView(group: group, userId: entry.value, usrname: entry.key)
            }
        }
    }

}
