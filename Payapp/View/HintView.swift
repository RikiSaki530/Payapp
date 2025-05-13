//
//  HintView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/13.
//

import SwiftUI

struct HintView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("アプリの使用方法")
                    .font(.title)
                    .bold()

                Group {
                    Text("1. アカウントの作成・ログイン")
                        .font(.headline)
                    Text("""
                    ・アプリを初めて起動した際には、メールアドレスとパスワードでアカウントを作成してください。
                    ・すでにアカウントをお持ちの方は、ログイン画面からサインインできます。
                    """)
                }

                Group {
                    Text("2. グループの作成・参加")
                        .font(.headline)
                    Text("""
                    ・管理者ユーザーは、新しいグループを作成できます。
                      グループ名を入力し、必要に応じて招待コードを発行してください。
                    ・一般ユーザーは、管理者から共有された招待コードを入力してグループに参加できます。
                    """)
                }

                Group {
                    Text("3. 部員の管理")
                        .font(.headline)
                    Text("""
                    ・部員（メンバー）をグループに追加・削除できます。
                    ・部員リストは左にスワイプすることで削除できます（管理者のみ可能）。
                    ・管理者は他の部員を管理者にすることができます。
                    """)
                }

                Group {
                    Text("4. 支払い項目の設定")
                        .font(.headline)
                    Text("""
                    ・支払うべき項目（部費、イベント費など）を登録できます。
                    ・支払い項目もスワイプして削除可能です（管理者のみ可能）。
                    """)
                }

                Group {
                    Text("5. 支払い状況の確認・更新")
                        .font(.headline)
                    Text("""
                    ・各部員の支払い状況は、記号やステータス（⭕️ 支払済み、❌ 未払い）で表示されます。
                    ・管理者のみがこの支払いステータスをタップして変更できます。
                    ・一般ユーザーは支払い状況を確認できますが、変更はできません。
                    """)
                }

                Group {
                    Text("6. アカウントの削除")
                        .font(.headline)
                    Text("""
                    ・設定画面から自分のアカウントを削除できます。
                    """)
                }
            }
            .padding()
        }
        .navigationTitle("使い方")
    }
}
