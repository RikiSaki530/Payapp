//
//  MemberEntry.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/12.
//

import SwiftUI

struct MemberEntry: Identifiable {
    let key: String
    let value: String
    var id: String { key } // ForEach用
}
