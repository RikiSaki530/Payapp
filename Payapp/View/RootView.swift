//
//  RootView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/13.
//

import SwiftUI
import FirebaseFirestore

struct RootView: View {
    @State private var isLoading = true
    @State private var isLoggedIn = false
    @State private var existingUser = User(name: "", Mailaddress: "", admin: [:], groupList: [:], UserID: "")

    var body: some View {
        Group {
            if isLoading {
                ProgressView("読み込み中…")
            } else if isLoggedIn {
                GroupListView(existingUser: existingUser)
            } else {
                OpneUIView()
            }
        }
        .onAppear {
            checkLogin()
        }
    }

    func checkLogin() {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            existingUser.UserID = userID
            existingUser.Mailaddress = UserDefaults.standard.string(forKey: "userEmail") ?? ""
            existingUser.name = UserDefaults.standard.string(forKey: "userName") ?? ""

            let db = Firestore.firestore()
            db.collection("User").document(userID).getDocument { document, error in
                defer { isLoading = false }
                if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    existingUser.name = data["name"] as? String ?? ""
                    existingUser.Mailaddress = data["Mailaddress"] as? String ?? ""
                    existingUser.admin = data["admin"] as? [String: Bool] ?? [:]
                    existingUser.groupList = data["groupList"] as? [String: String] ?? [:]
                    isLoggedIn = true
                } else {
                    print("ユーザーデータが取得できません")
                    isLoggedIn = false
                }
            }
        } else {
            isLoading = false
            isLoggedIn = false
        }
    }
}
