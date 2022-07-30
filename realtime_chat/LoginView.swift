//
//  ContentView.swift
//  realtime_chat
//
//  Created by Vinh Le on 29.7.2022.
//

import SwiftUI
import Firebase

enum LoginMode {
    case login
    case createNewAccount
}

struct LoginView: View {
    @State var mode = LoginMode.login
    @State var email = ""
    @State var password = ""
    
    init() {
        // Init firebase SDK
        // https://console.firebase.google.com/u/0/project/swiftui-realtime-chat/overview
        FirebaseApp.configure()
    }
        
    var body: some View {
        NavigationView {
            ScrollView {
                Picker(selection: $mode, label: Text("Picker here")) {
                    Text("Login").tag(LoginMode.login)
                    Text("Create account").tag(LoginMode.createNewAccount)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(5)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 64))
                    .padding()
                
                TextField("Email", text: $email).padding().keyboardType(.emailAddress).autocapitalization(.none).background(.white).cornerRadius(4)
                SecureField("Password", text: $password).padding().background(.white).cornerRadius(4)
                
                Button {
                    handleAuthenticate()
                } label: {
                    HStack {
                        Spacer()
                        Text(mode == LoginMode.login ? "Login" : "Create account")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                        Spacer()
                    }.background(Color.blue)
                }.cornerRadius(4)
            }
            .navigationTitle(mode == LoginMode.login ? "Login" : "Create new account")
            .padding(.horizontal, 20)
            .background(Color(.init(white: 0, alpha: 0.05)))
        }
    }
    
    private func handleAuthenticate() {
        if mode == LoginMode.login {
            print("logging in to your account")
        } else if mode == LoginMode.createNewAccount {
            print("create new account")
        } else {
            print("no action")
        }
        
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
