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
            
            VStack(spacing: 30){
                
                Spacer()
                    .frame(height : 25) // ← 幅を指定
                
                
                NavigationLink(destination: GroupCreationView(user: $existingUser)) {
                    Text("グループを作成")
                        .foregroundColor(.black)
                        .frame(width: 300 , height: 60)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                
                NavigationLink(destination: ContentView(user: $existingUser)) {
                    Text("グループ")
                        .foregroundColor(.black) // ← テキストの色も明示
                        .frame(width: 300 , height: 60)
                        .background(Color.yellow)
                        .cornerRadius(15)
                }
                
                
                
                Spacer()
                
            }
        }
    }
}



struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: false, leader: false, groupList : [], UserID: 0)
        
        GroupListView(existingUser: $newUser)
    }
}
