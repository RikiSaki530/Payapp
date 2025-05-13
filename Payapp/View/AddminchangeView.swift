//
//  AddminchangeView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/12.
//

import SwiftUI
import FirebaseFirestore

struct AddminchangeView: View {
    @ObservedObject var group: GroupData

    let userId: String
    let usrname: String

    @State private var isAdmin: Bool = false
    @State private var isLoaded: Bool = false

    var body: some View {
        HStack {
            Text(usrname)
            Spacer()
            if isLoaded {
                Toggle("Admin", isOn: Binding(
                    get: { isAdmin },
                    set: { newValue in
                        isAdmin = newValue
                        updateAdminStatus(userID: userId, adminStatus: newValue, key: group.groupCode)
                    }
                ))
                .labelsHidden()
            } else {
                ProgressView() // 読み込み中インジケーター
            }
        }
        .onAppear {
            fetchUserData(userID: userId)
        }
    }

    // Firestoreからユーザー情報を取得し、admin[groupCode] を反映
    func fetchUserData(userID: String) {
        let db = Firestore.firestore()
        db.collection("User").document(userID).getDocument { document, error in
            if let error = error {
                print("❌ Firestore取得失敗: \(error.localizedDescription)")
                return
            }

            guard let data = document?.data(),
                  let adminDict = data["admin"] as? [String: Bool] else {
                print("❗️adminフィールドなし")
                return
            }

            DispatchQueue.main.async {
                self.isAdmin = adminDict[group.groupCode] ?? false
                self.isLoaded = true
            }
        }
    }

    // Firestoreにadminステータスを保存
    func updateAdminStatus(userID: String, adminStatus: Bool, key: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("User").document(userID)

        userRef.updateData([
            "admin.\(key)": adminStatus
        ]) { error in
            if let error = error {
                print("❌ 管理者ステータス更新失敗: \(error.localizedDescription)")
            } else {
                print("✅ 管理者ステータス更新成功")
            }
        }
    }
}
