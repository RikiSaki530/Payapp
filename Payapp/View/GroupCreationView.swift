//
//  GroupCreationView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループを作る画面

import SwiftUI

struct GroupCreationView: View {
    
    @Binding var user : User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], MemberList: [:])
    
    var body: some View {
     
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループ名" , text: $group.groupName)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)

                
                NavigationLink("グループを作成"){
                    ContentView(user:$user , group:$group)
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 60)
                .background(Color.mint)
                .cornerRadius(15)
            }
            
        }
    }
    
    func CanMakeGroup(){
        
        //グループリーダー規定
        group.Leader[user.name] = user.UserID
        group.MemberList[user.name] = user.UserID
        //groupListに追加
        user.groupList.append(group)
        //adminは無条件にtrue
        user.admin[group.groupCode] = true
        
    }
}

struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:],groupList : [], UserID: 0)
        
        GroupCreationView(user: $newUser)
    }
}
