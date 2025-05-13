//
//  Members.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//
import SwiftUI


struct ClubMember: Identifiable, Codable, Hashable {
    var id: UUID = UUID()                // Firestore保存時に除外しても良い
    var name: String                     // 名前
    var grade: String                   // 学年
    var paymentStatus: [PayItem]        // 支払い状況

    // イニシャライザ
    init(name: String, grade: String, paymentStatus: [PayItem] = []) {
        self.name = name
        self.grade = grade
        self.paymentStatus = paymentStatus
    }

    // Firestoreのデータに含まれない'id'をデコードしない
    enum CodingKeys: String, CodingKey {
        case name
        case grade
        case paymentStatus
        // ⚠️ id は除外
    }

    // Firestoreから取得したデータを元にClubMemberのインスタンスを生成する
    init(from firestoreData: [String: Any]) {
        self.name = firestoreData["name"] as? String ?? ""
        self.grade = firestoreData["grade"] as? String ?? ""
        
        // FirestoreのデータをPayItemとしてデコード
        if let payItemsData = firestoreData["paymentStatus"] as? [[String: Any]] {
            self.paymentStatus = payItemsData.map { data in
                let name = data["name"] as? String ?? ""
                let price = data["price"] as? Int
                let paystatus = data["paystatus"] as? String ?? ""
                return PayItem(name: name, price: price, paystatus: paystatus)
            }
        } else {
            self.paymentStatus = []
        }
    }

    // ClubMemberを辞書形式に変換
    func toDictionary() -> [String : Any] {
        return [
            "name" : self.name,
            "grade" : self.grade,
            "paymentStatus" : self.paymentStatus.map { $0.toDictionary() }
        ]
    }
}

