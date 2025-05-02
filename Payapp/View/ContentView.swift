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
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ
    
    var body: some View {
        NavigationStack {
            Text("団体名")
                .font(.largeTitle)
            
            List {
                // 名前から誰が何を払ったかがわかるようにする
                NavigationLink("名前") {
                    MemberView() // MemberViewへデータを渡す
                        .navigationTitle("Members")
                        .environmentObject(Memberdata) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
                //支払いするものについて誰が払った払ってないをlist化
                NavigationLink("支払い項目"){
                    MastPayView()
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                    
                }
                //未払いのみをピックアップして誰が何を払っていないのかを把握
                NavigationLink("未払いリスト"){
                    UnpaidView()
                        .environmentObject(listData)
                        .environmentObject(Memberdata)
                }
                
                Section("追加"){
                    NavigationLink("支払い項目追加"){
                        PayListaddView()
                            .environmentObject(listData)
                            .environmentObject(Memberdata)
                    }
                    NavigationLink("メンバー追加"){
                        MemberAddView()
                            .environmentObject(Memberdata)
                            .environmentObject(listData)
                    }
                }
                
                NavigationLink("設定"){
                    SettingView()
                }
                Section("管理用"){
                    NavigationLink("admin"){
                        
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem{
                ShareLink(item: "このグループに参加してね！コード: " ){
                    HStack {
                        Image(systemName: "square.and.arrow.up")
        
        .navigationBarBackButtonHidden(true) 
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
