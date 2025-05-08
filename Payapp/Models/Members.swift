//
//  Members.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct ClubMember: Identifiable, Codable, Hashable {
    var id = UUID()                // Firestore保存時に除外してもOK
    var name: String              // 名前
    var schoolnumber: String     // 学籍番号
    var grade: String            // 学年
    var paymentStatus: [PayItem] // 支払い状況

    init(name: String, grade: String, schoolnumber: String, paymentStatus: [PayItem] = []) {
        self.name = name
        self.grade = grade
        self.schoolnumber = schoolnumber
        self.paymentStatus = paymentStatus
    }
    
    // Firestore用: 辞書に変換
    func toDict() -> [String: Any] {
        return [
            "name": name,
            "schoolnumber": schoolnumber,
            "grade": grade,
            "paymentStatus": paymentStatus.map { $0.toDict() } // PayItemも辞書に変換
        ]
    }
    
}
