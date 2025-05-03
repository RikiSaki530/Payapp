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
            
            VStack(spacing: 20){
                
                Spacer()
                    .frame(height : 25) // ← 幅を指定
                
                NavigationLink("グループを作成") {
                    GroupCreationView(user: $existingUser)
                }
                        .foregroundColor(.black)
                        .frame(width: 300 , height: 60)
                        .background(Color.green)
                        .cornerRadius(15)
                
                NavigationLink("グループに参加"){
                    GroupJoinView(user: $existingUser)
                }
                    .foregroundColor(.black) // ← テキストの色も明示
                    .frame(width: 300 , height: 60)
                    .background(Color.mint)
                    .cornerRadius(15)
                
                
                ForEach($existingUser.groupList){$group in
                    NavigationLink{
                        ContentView(user: $existingUser , group: $group)
                    }label: {
                        Text(group.groupName)
                    }
                            .foregroundColor(.black) // ← テキストの色も明示
                            .frame(width: 300 , height: 60)
                            .background(Color.mint)
                            .cornerRadius(15)
                }
                
                
                Spacer()
                
            }
        }
    }
}



struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:], groupList : [], UserID: 0)
        
        GroupListView(existingUser: $newUser)
    }
}
