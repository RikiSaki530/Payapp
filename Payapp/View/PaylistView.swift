//
//  PaylistView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore


struct PaylistView: View {
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    @Binding var member: ClubMember
    @State private var selectValues: [UUID: Int] = [:]

    var body: some View {
        List {
            ForEach(member.paymentStatus) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    
                    Picker("", selection: Binding(
                        get: {
                            // 既存のpaystatusを基に初期値を設定
                            selectValues[item.id] ?? symbolToTag(item.paystatus)
                        },
                        set: { newValue in
                            
                            // 管理者であることを確認
                            if user.admin[group.groupCode] == true {
                            
                                // selectValuesに新しい選択を保存
                                selectValues[item.id] = newValue
                                
                                // member.paymentStatus内で対応するアイテムを更新
                                if let index = member.paymentStatus.firstIndex(where: { $0.id == item.id }) {
                                    // tag -> symbolに変換して更新
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
                        .disabled(!(user.admin[group.groupCode] ?? false)) // 管理者でないと無効
                    
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

    


