//
//  MemberAddView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct MemberAddView : View{
    
    @EnvironmentObject var Memberdata :  MemberList
    @EnvironmentObject var listData : PayList
    
    @State var newMember : ClubMember = ClubMember(name: "", grade: "", schoolnumber: "" , paymentStatus:[])
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading){
            Form {
                //名前読み取り
                Section("名前") {
                    TextField("Name", text: $newMember.name)
                }
                //学年
                Section("学年"){
                    TextField("grade" , text: $newMember.grade)
                }
                //学籍番号
                Section("学籍番号"){
                    TextField("schoolnuber" , text: $newMember.schoolnumber)
                }
            }
        }
        .onAppear{
            newMember.paymentStatus = listData.paylistitem
        }
        
        .toolbar{
            ToolbarItem{
                Button("完了"){
                    if !Memberdata.members.contains(where: { $0.name == newMember.name }) {
                        Memberdata.members.append(newMember)
                    }
                    dismiss()
                }
            }
        }
        
    }
}
    
struct MemberAddView_Previews : PreviewProvider{
    static var previews: some View {
        
        let dummyMemberData = MemberList()
        let dummyListData = PayList()
        
        NavigationStack(){
            MemberAddView()
                .environmentObject(dummyMemberData)
                .environmentObject(dummyListData)
        }
    }
}
