//
//  GroupCreationView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループを作る画面

import SwiftUI
import FirebaseFirestore

struct GroupCreationView: View {
    
    @Binding var user : User
    @State var group = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    @State private var shouldNavigate = false
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ

    
    var body: some View {
     
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループ名" , text: $group.groupName)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("グループを作成") {
                    if !group.groupName.isEmpty{
                        CanMakeGroup()
                        shouldNavigate = true  // ← これで遷移が発動する
                    }
                }
                .colorMultiply(.black)
                .frame(width: 300 , height: 50)
                .background(Color.yellow)
                .cornerRadius(10)
                
            }
                .navigationDestination(isPresented: $shouldNavigate) {
                    ContentView(user: $user, group: $group)
                        .environmentObject(Memberdata)
                        .environmentObject(listData)
                }
            
        }
    }
    
    
    func CanMakeGroup(){
        
        //グループのIDを設定
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document()
        group.groupCode = docRef.documentID

        //グループリーダー規定
        group.Leader[user.name] = user.UserID
        group.AccountMemberList[user.name] = user.UserID
        //groupListに追加
        user.groupList.append(group)
        //adminは無条件にtrue
        user.admin[group.groupCode] = true
        
        group.groupFireAdd()
        user.userfirechange()
    }
}

struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:],groupList : [], UserID: 0)
        
        GroupCreationView(user: $newUser)
    }
}
