//
//  RootView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/13.
//

import SwiftUI
import FirebaseFirestore


enum Destination: Hashable {
    case OpenUi
    case SingUp
    case Login
    case NameSetting(newUser: User)
    case GroupList(existingUser : User)
    case Content(user : User , group : GroupData)
    case Setting(user : User, group : GroupData)
    case Accoutndelete(user: User , group : GroupData)
    case GroupCreateaion(User: User)
    case GroupJoin(User: User)
    case Member(user : User , group : GroupData)
    case MastPay(user : User , group : GroupData)
    case Unpaid(user : User , group : GroupData)
    case MemberAdd(group : GroupData)
    case PayListAdd(group : GroupData)
    case Hint
    case Addmin(user : User , group : GroupData)
    case StatusChange(group : GroupData)
}

struct RootView: View {
    @State private var isLoading = true
    @State private var isLoggedIn = false
    @State private var existingUser = User(name: "", Mailaddress: "", admin: [:], groupList: [:], UserID: "")
    
    @State private var message: String = ""
    @State private var path = NavigationPath()
    
    @StateObject var Memberdata = MemberList() // ClubMembersデータ
    @StateObject var listData = PayList() // PayListデータ

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if isLoading {
                    ProgressView("読み込み中…")
                } else if isLoggedIn {
                    // 最初に遷移する画面（仮でも何か表示する必要がある）
                    GroupListView(existingUser: existingUser, path: $path)
                } else {
                    OpneUIView(path: $path)
                }
            }
            .onAppear {
                checkLogin()
            }
            
            //caseはここに全て書く
            //@Binding var path: NavigationPath
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .OpenUi:
                    OpneUIView(path: $path)
                case .GroupList(let existingUser):
                    GroupListView(existingUser: existingUser, path: $path)
                case .SingUp:
                    SingUpView(path: $path)
                case .Login:
                    LoginView(path: $path)
                case .NameSetting(let newUser):
                    NameSettingView(path: $path, newUser: newUser)
                case .Content(let user, let group):
                    ContentView(user: user, group: group , path : $path)
                case .Setting(let user , let group):
                    SettingView(user: user, group: group , path : $path)
                case .Accoutndelete(let user , let group):
                    AccountDeleteView(user: user, group: group , path : $path)
                case .GroupCreateaion(let user):
                    GroupCreationView(user: user , path : $path)
                case .GroupJoin(let user) :
                    GroupJoinView(user: user, path: $path)
                case .Member(let user , let group):
                    MemberView(user: user, group: group , path : $path)
                case .MastPay(let user , let group):
                    MastPayView(user: user, group: group , path : $path)
                case .Unpaid(let user , let group):
                    UnpaidView(user: user, group: group , path : $path)
                case .MemberAdd(let group):
                    MemberAddView(group: group , path : $path)
                case .PayListAdd(let group):
                    PayListaddView(group: group , path : $path)
                case .Hint:
                    HintView(path : $path)
                case .Addmin(let user , let group):
                    AddminView(user: user, group: group , path : $path)
                case .StatusChange(let group):
                    StatusChangeView(group: group , path : $path)
                }
            }
            // ログイン完了後に自動遷移させる
        }
        .environmentObject(Memberdata)
        .environmentObject(listData)
    }

    func checkLogin() {
        message = "読み込み中…"
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            existingUser.UserID = userID
            existingUser.Mailaddress = UserDefaults.standard.string(forKey: "userEmail") ?? ""
            existingUser.name = UserDefaults.standard.string(forKey: "userName") ?? ""
            
            let db = Firestore.firestore()
            db.collection("User").document(userID).getDocument { document, error in
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
                    message = "ログイン情報が見つかりません"
                }
                isLoading = false
            }
        } else {
            isLoggedIn = false
            message = "ログイン情報が見つかりません"
            isLoading = false
        }
        print("1コメ")
    }
    
}
