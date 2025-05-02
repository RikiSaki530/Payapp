//
//  GroupselectView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//

//グループを作るか入るか選択

import SwiftUI

struct GroupselectView: View {
    var body: some View {
        
        NavigationStack{
            
            HStack{
                Spacer()
                NavigationLink("グループを作成"){
                    GroupCreationView()
                }
                    .colorMultiply(.black)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                
                Spacer()
                
                NavigationLink("グループに参加"){
                    GroupJoinView()
                }
                .colorMultiply(.black)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                
                Spacer()
            }
        }
    }
}

struct GroupselectView_Previews: PreviewProvider {
    static var previews: some View {
        GroupselectView()
    }
}
