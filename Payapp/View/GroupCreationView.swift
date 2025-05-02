//
//  GroupCreationView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループを作る画面

import SwiftUI

struct GroupCreationView: View {
    var body: some View {
     
        NavigationStack{
            Form{
                NavigationLink("グループを作成"){
                    ContentView()
                }
            }
        }
    }
}

struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCreationView()
    }
}
