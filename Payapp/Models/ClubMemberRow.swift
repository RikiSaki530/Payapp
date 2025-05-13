//
//  ClubMemberRow.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct ClubMemberRow : View{
    @Binding var member : ClubMember
    
    var body: some View{
        HStack{
            Text(member.name)
                .font(.title2)
            Spacer()
                .frame(width: 100)
            Text(String(member.grade))
                .font(.title2)
        }
     }
}


