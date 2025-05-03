//
//  ContentView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct ContentView: View {
    
    @Binding var user :User
    @Binding var group : GroupData
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ
    
    var body: some View {
        NavigationStack {
            Text("団体名")
                .font(.largeTitle)
            
            List {
                // 名前から誰が何を払ったかがわかるようにする
                NavigationLink("名前") {
                    MemberView(user: $user , group: $group) // MemberViewへデータを渡す
                        .navigationTitle("Members")
                        .environmentObject(Memberdata) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
                //支払いするものについて誰が払った払ってないをlist化
                NavigationLink("支払い項目"){
                    MastPayView(user: $user , group: $group)
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                    
                }
                //未払いのみをピックアップして誰が何を払っていないのかを把握
                NavigationLink("未払いリスト"){
                    UnpaidView(user: $user , group: $group)
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                }
                
                Section("追加"){
                    NavigationLink("メンバー追加"){
                        MemberAddView()
                            .environmentObject(Memberdata)
                            .environmentObject(listData)
                    }
                    
                    NavigationLink("支払い項目追加"){
                        PayListaddView()
                            .environmentObject(listData)
                            .environmentObject(Memberdata)
                    }
                    
                }
                
                NavigationLink("設定"){
                    SettingView(user : $user)
                }
                
                if (user.admin[group.groupCode] ?? false) == true{
                    Section("管理用"){
                        NavigationLink("admin"){
                            AddminView(user: $user, group: $group)
                        }
                    }
                    
                }
            }
        }
        .toolbar{
            ToolbarItem{
                ShareLink(item: "このグループに参加してね！コード: \($group.groupCode)" ){
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
}

/**
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser1 = User(name : "" ,Mailaddress: "", Password: "", admin: false,  groupList : [], UserID: 0)
        
        @State var newUser2 = User(name : "" ,Mailaddress: "", Password: "", admin: true,  groupList : [], UserID: 0)
        
        @State var newgroup = GroupData(groupName: "", groupCode: "", Leader: "", MemberList: [])
        
        
        VStack{
            ContentView(user: $newUser1 , group: $newgroup)
            ContentView(user:$newUser2 , group: $newgroup)
        }
    }
}
*/
