//
//  PayList.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

//リスト作成
class PayList : ObservableObject {
    
    //Payの要素をlistで管理
    @Published var paylistitem :[PayItem] = []

}
