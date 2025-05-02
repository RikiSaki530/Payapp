//
//  MemberView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct MemberView: View {
    
    @EnvironmentObject var data: MemberList // 親ビューから渡されたデータ
    @EnvironmentObject var listData: PayList // 親ビューから渡されたデータ
    
    var body: some View {
        List {
            // メンバーのリストを表示
            ForEach($data.members) { $member in
                NavigationLink {
                    IndividualView(individual: $member) // 個別のメンバー詳細を表示
                } label: {
                    ClubMemberRow(member: $member) // ClubMemberRowに渡す
                }
            }
            .onDelete { indexSet in
                data.members.remove(atOffsets: indexSet)
                                }
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("追加") {
                    MemberAddView()
                        .environmentObject(data) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
            }
        }
    }
}

