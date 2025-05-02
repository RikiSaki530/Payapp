//
//  Members.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

class ClubMember: ObservableObject, Identifiable {
    
    var name: String //名前
    var schoolnumber: String //学籍番号
    @Published var grade: String //学年
    @Published var paymentStatus: [PayItem] = [ ]// 支払い状況を保存
    
    var id = UUID() // `Identifiable` に必要
    
    
    
    init(name: String, grade: String, schoolnumber: String, paymentStatus: [PayItem]=[]  ) {
        self.name = name
        self.grade = grade
        self.schoolnumber = schoolnumber
        self.paymentStatus = paymentStatus
    }
    
    
}
