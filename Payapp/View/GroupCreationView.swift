//
//  GroupCreationView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループを作る画面

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct GroupCreationView: View {
    
    @ObservedObject var user : User
    
    @State var newgroup = GroupData(groupName: "", groupCode: "", Leader: [:], AccountMemberList: [:] , MemberList: [] , PayList: [])
    
    @State private var groupname = ""
    
    @State private var shouldNavigate = false
    @State private var errorMessage: String?   // エラーメッセージ用
    
    @StateObject var Memberdata = MemberList()
    @StateObject var listData = PayList() // PayListデータ
    
    
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing : 30){
                
                TextField("グループ名" , text: $groupname)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                Button("グループを作成") {
                    if groupname.isEmpty {
                        errorMessage = "名前を入力してください。"
                    }else{
                        CanMakeGroup()
                        shouldNavigate = true
                    }
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 50)
                .background(Color.yellow)
                .cornerRadius(10)
                
                // エラーメッセージがあれば表示
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                
            }
            
            
            .navigationDestination(isPresented: $shouldNavigate) {
                ContentView(user: user, group: newgroup )
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
        newgroup.groupName = groupname
        
        // グループ名が空かチェック
        if newgroup.groupName.isEmpty {
            print("❌ グループ名が空です！")
            return
        }
            
        // グループコードが空かチェック
        if newgroup.groupCode.isEmpty {
            print("❌ グループコードが空です！")
            return
        }
        
        //グループリーダー規定
        newgroup.Leader[user.name] = user.UserID
        newgroup.AccountMemberList[user.name] = user.UserID
        //groupListに追加
        user.groupList[newgroup.groupName] = newgroup.groupCode
        print("✅ AccountMemberList:", newgroup.AccountMemberList)
        //adminは無条件にtrue
        user.admin[newgroup.groupCode] = true
        
        newgroup.MemberList = []
        newgroup.PayList = []
        
        newgroup.fireadd()
        user.fireadd()
        
    }
}
