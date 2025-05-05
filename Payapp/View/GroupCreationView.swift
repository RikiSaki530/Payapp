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
    @State var newgroup = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    @State private var shouldNavigate = false
    
    @StateObject var Memberdata = MemberList()
    @StateObject var listData = PayList() // PayListデータ

    
    var body: some View {
     
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループ名" , text: $newgroup.groupName)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("グループを作成") {
                    if !newgroup.groupName.isEmpty {
                        CanMakeGroup()
                            shouldNavigate = true
                    }
                }
                .colorMultiply(.black)
                .frame(width: 300 , height: 50)
                .background(Color.yellow)
                .cornerRadius(10)
                
            }
                .navigationDestination(isPresented: $shouldNavigate) {
                    ContentView(user: $user, group: $newgroup)
                        .environmentObject(Memberdata)
                        .environmentObject(listData)
                }
            
        }
    }
    
    
    func CanMakeGroup(){
            
        //グループのIDを設定
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document()
        newgroup.groupCode = docRef.documentID
        
        //グループリーダー規定
        newgroup.Leader[user.name] = user.UserID
        newgroup.AccountMemberList[user.name] = user.UserID
        //groupListに追加
        user.groupList.append(newgroup)
        //adminは無条件にtrue
        user.admin[newgroup.groupCode] = true
        
        newgroup.groupFireAdd()
        user.userfirechange()
        
    }
    
}

