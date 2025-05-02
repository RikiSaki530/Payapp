//
//  SettingView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//
import SwiftUI

struct SettingView: View {
    var body: some View {
        
        NavigationStack{
            NavigationLink("アカウント削除"){
                DeleteAccountView()
            }
        }
    }
}
