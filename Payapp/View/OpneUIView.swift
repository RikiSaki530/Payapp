//
//  Untitled 2.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

//入ってきて一番最初の画面
import SwiftUI

struct OpneUIView: View {
    var body: some View {
        NavigationStack{
            
            VStack(spacing : 50){
                
                Text("会計app")
                    .font(.largeTitle)
                
                NavigationLink("ログイン"){
                    LoginView()
                }
                    .colorMultiply(.black)
                    .frame(width: 300 , height: 60)
                    .background(Color.yellow)
                    .cornerRadius(10)
                
                NavigationLink("新規登録"){
                    SingUpView()
                }
                    .colorMultiply(.black)
                    .frame(width: 300 , height: 60)
                    .background(Color.yellow)
                    .cornerRadius(10)
                
            }
        }
    }
}

struct OpneUiview_Previews: PreviewProvider {
    static var previews: some View {
        OpneUIView()
    }
}
