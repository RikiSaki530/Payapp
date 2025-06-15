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
            
            if !member.grade.isEmpty{
                Text(member.grade)
                    .font(.title2)
            }
        }
     }
}


struct ClubMemberRow_Previews : PreviewProvider {
    static var previews: some View {
        @State var member = ClubMember(name: "riki" , grade:"2" , paymentStatus: [])
        List{
            ClubMemberRow(member: $member)
        }
    }
}
