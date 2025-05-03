//
//  IndividualView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct IndividualView : View{
    
    @Binding var individual : ClubMember
    
    @Binding var user : User
    @Binding var group : GroupData
    
    var body: some View{
        VStack{
            Text("名前 : "+individual.name)
                    .font(.title)
            
            Text("学年 : "+(individual.grade))
                .font(.title)
            Text("学籍番号 : "+(individual.schoolnumber))
                .font(.title)
            
            PaylistView(user: $user, group: $group, member: individual)
        }
    }
}
