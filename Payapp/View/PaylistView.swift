//
//  PaylistView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct PaylistView: View {
    
    @Binding var user : User
    @Binding var group : GroupData
    
    @State var member: ClubMember
    @State private var selectValues: [UUID: Int] = [:]

    var body: some View {
        List {
            ForEach(member.paymentStatus) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    
                    Picker("", selection: Binding(
                        get: {
                            selectValues[item.id] ?? symbolToTag(item.paystatus)
                        },
                        set: { newValue in
                            if !(user.admin[group.groupCode] ?? false) {
                                selectValues[item.id] = newValue
                                if let index = member.paymentStatus.firstIndex(where: { $0.id == item.id }) {
                                    member.paymentStatus[index].paystatus = tagToSymbol(newValue)
                                }
                            }
                        }
                    )) {
                        Text("⭕️").tag(1)
                        Text("❌").tag(2)
                        Text("➖").tag(3)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 150)
                    .disabled(!(user.admin[group.groupCode] ?? false))
                }
            }
        }
        .onAppear {
            for item in member.paymentStatus {
                selectValues[item.id] = symbolToTag(item.paystatus)
            }
        }
    }

    func symbolToTag(_ symbol: String) -> Int {
        switch symbol {
        case "⭕️": return 1
        case "❌": return 2
        case "➖": return 3
        default: return 2
        }
    }

    func tagToSymbol(_ tag: Int) -> String {
        switch tag {
        case 1: return "⭕️"
        case 2: return "❌"
        case 3: return "➖"
        default: return "❌"
        }
    }
}

    

/**
struct PaylistView_Previews : PreviewProvider{
    static var previews: some View {
        let  previewMember = ClubMember(
            name: "toshi",
            grade: "8",
            schoolnumber: "888",
            paymentStatus: [
                PayItem(name: "4月部費", price: 1000, paystatus: "⭕️"),
                PayItem(name: "5月部費", price: 1000, paystatus: "❌"),
                PayItem(name: "6月部費", price: 1000, paystatus: "⭕️")
            ]
        )
        
        VStack {
            Text("管理者プレビュー")
            PaylistView(member: previewMember, isAdmin: true)
            
            Text("一般ユーザープレビュー")
            PaylistView(member: previewMember, isAdmin: false)
        }
    }
}
*/
