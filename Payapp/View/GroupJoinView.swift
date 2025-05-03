//
//  GroupJoinView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループに所属する画面
import SwiftUI


struct GroupJoinView: View {
    
    @Binding var user : User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], MemberList: [:])
    
    var body: some View {
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループの参加コード" , text: $group.groupCode)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                
                NavigationLink("参加"){
                    ContentView(user: $user , group: $group)
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 60)
                .background(Color.green)
                .cornerRadius(15)
            }
        }
    }
    
    //参加したときにしてほしいこと
    func CanJoinGroup(){
        
        //groupListに追加
        user.groupList.append(group)
        user.admin[group.groupCode] = false
        
    }
}

struct GroupJoinView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:],  groupList : [], UserID: 0)
        
        GroupJoinView(user: $newUser)
    }
}
