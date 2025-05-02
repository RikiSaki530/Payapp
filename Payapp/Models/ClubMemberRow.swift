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

struct ClubMemberRow_Previews : PreviewProvider{
    static var previews: some View {
        ClubMemberRow(member: .constant(ClubMember(name: "toshi", grade: "8", schoolnumber: "888", paymentStatus: [])))
    }
}
