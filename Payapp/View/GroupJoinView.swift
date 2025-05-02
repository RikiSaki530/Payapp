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
    
    var body: some View {
        NavigationStack{
            
            VStack(spacing : 10){
                
                NavigationLink("参加"){
                    ContentView(user: $user)
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 60)
                .background(Color.green)
                .cornerRadius(15)
            }
        }
    }
}

struct GroupJoinView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: false, leader: false, groupList : [], UserID: 0)
        
        GroupJoinView(user: $newUser)
    }
}
