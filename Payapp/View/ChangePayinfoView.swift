//
//  ChangePayinfoView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/26.
//
import SwiftUI
import FirebaseFirestore

struct ChangePayinfoView: View {
    
    @ObservedObject var user: User
    @ObservedObject var group: GroupData
    
    @EnvironmentObject var listData: PayList
    @EnvironmentObject var Memberdata: MemberList
    
    @Binding var payitem: PayItem
    
    @State private var showAlert = false
    @State private var isDuplicate = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                // 支払項目名
                Section("項目名") {
                    TextField("項目名", text: $payitem.name)
                }
                
                // 金額
                Section("金額") {
                    TextField("金額", value: $payitem.price, format: .number)
                        .keyboardType(.numberPad)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完了") {
                    if payitem.name.isEmpty {
                        isDuplicate = false
                        showAlert = true
                    } else if listData.paylistitem.contains(where: { $0.name == payitem.name && $0.id != payitem.id }) {
                        isDuplicate = true
                        showAlert = true
                    } else {
                        updatePayItem()
                        memberfireadd()
                        paylistfireadd()
                        dismiss()
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            if isDuplicate {
                return Alert(
                    title: Text("確認"),
                    message: Text("同じ名前の支払項目があります。保存しますか？"),
                    primaryButton: .default(Text("保存")) {
                        updatePayItem()
                        memberfireadd()
                        paylistfireadd()
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("キャンセル"))
                )
            } else {
                return Alert(
                    title: Text("エラー"),
                    message: Text("項目名を入力してください。"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func updatePayItem() {
        if let index = listData.paylistitem.firstIndex(where: { $0.id == payitem.id }) {
            listData.paylistitem[index].name = payitem.name
            listData.paylistitem[index].price = payitem.price
            
            
            for i in Memberdata.members.indices {
                if let psIndex = Memberdata.members[i].paymentStatus.firstIndex(where: { $0.id == payitem.id }) {
                    Memberdata.members[i].paymentStatus[psIndex].name = payitem.name
                    Memberdata.members[i].paymentStatus[psIndex].price = payitem.price
                }
            }

        }
        
    }

    func paylistfireadd() {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Pdata = listData.paylistitem.map{ $0.toDictionary() }
        
        docRef.updateData([
            "PayList": Pdata
        ]) { error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("PayListAddView:データを更新しました")
            }
        }
    }
    
    func memberfireadd(){
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Mdata = Memberdata.members.map { $0.toDictionary() }

        docRef.updateData([
            "MemberList": Mdata
        ]){ error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("PayListAddView:データを更新しました")
            }
        }
    }
}
