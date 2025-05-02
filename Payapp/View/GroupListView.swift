//
//  GroupListView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI

struct GroupListView: View {
    
    @Binding var existingUser :User
    
    var body: some View {
        NavigationStack{
            
        }
    }
}



struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: false, leader: false, groupList : [], UserID: 0)
        
        GroupListView(existingUser: $newUser)
    }
}
