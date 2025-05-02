//
//  GroupJoinView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループに所属する画面
import SwiftUI


struct GroupJoinView: View {
    var body: some View {
        NavigationStack{
            Form{
                NavigationLink("グループに参加"){
                    ContentView()
                }
            }
        }
    }
}

struct GroupJoinView_Previews: PreviewProvider {
    static var previews: some View {
        GroupJoinView() 
    }
}
