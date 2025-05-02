//
//  GroupName.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI
import Firebase


class GroupData: ObservableObject {
    @Published var groupName: String = ""
    @Published var groupCode = ""
}
