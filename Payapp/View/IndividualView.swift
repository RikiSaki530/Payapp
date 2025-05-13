//
//  IndividualView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct IndividualView : View{
    
    @Binding var individual : ClubMember
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    var body: some View{
        VStack{
            Text("名前 : "+individual.name)
                    .font(.title)
            
            Text("学年 : "+(individual.grade))
                .font(.title)
            
            PaylistView(user: user, group: group, member: $individual)
        }
    }
}
