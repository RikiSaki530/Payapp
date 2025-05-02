//
//  IndividualView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct IndividualView : View{
    @Binding var individual : ClubMember
    
    var body: some View{
        VStack{
            Text("名前 : "+individual.name)
                    .font(.title)
            
            Text("学年 : "+(individual.grade))
                .font(.title)
            Text("学籍番号 : "+(individual.schoolnumber))
                .font(.title)
            
            PaylistView(member : individual, isAdmin: true )
        }
    }
}

struct IndividualView_PreViews : PreviewProvider{
    static var previews: some View {
        let previewMember = ClubMember(name: "toshi", grade: "8", schoolnumber: "888")
        IndividualView(individual: .constant(previewMember))
    }
}
