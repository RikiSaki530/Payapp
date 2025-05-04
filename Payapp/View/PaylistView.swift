//
//  PaylistView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore

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
                            if user.admin[group.groupCode] == true {
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
    
    func checkGroupExistence() {
        let db = Firestore.firestore()
        
        db.collection("Group").document(group.groupCode).getDocument { document, error in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            group.groupFireChange() // 変更処理を呼び出す
            
        }
    }
}

    


