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

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

class FirebaseManager: NSObject {
    // shared singleton
    static let shared = FirebaseManager()
    
    let auth: Auth
    
    // Using private so that consumers can use the singleton only
    private override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}

struct LoginView: View {
    @State var mode = LoginMode.login
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
        
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
                
                TextField("Email", text: $email)
                    .onChange(of: email, perform: { newValue in
                        if !errorMessage.isEmpty {
                            errorMessage = ""
                        }
                    })
                    .padding().keyboardType(.emailAddress).autocapitalization(.none).background(.white).cornerRadius(4)
                
                SecureField("Password", text: $password)
                    .onChange(of: password, perform: { newValue in
                        if !errorMessage.isEmpty {
                            errorMessage = ""
                        }
                    })
                    .padding().background(.white).cornerRadius(4)
                
                Text(!errorMessage.isEmpty ? errorMessage.firstUppercased : "").foregroundColor(.red)
                
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
            login()
        } else if mode == LoginMode.createNewAccount {
            createNewAccount()
        } else {
            print("no action")
        }
    }
    
    private func login() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                self.errorMessage = "failed to create new account \(err.localizedDescription)"
                return
            }
            
            print("login success", result?.user.uid)
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                self.errorMessage = "failed to create new account \(err.localizedDescription)"
                return
            }
            
            print("create user succeeded", result?.user)
        }
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
