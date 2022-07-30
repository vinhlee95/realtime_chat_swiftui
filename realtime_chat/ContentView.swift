//
//  ContentView.swift
//  realtime_chat
//
//  Created by Vinh Le on 29.7.2022.
//

import SwiftUI

struct ContentView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                Picker(selection: $isLoginMode, label: Text("Picker here")) {
                    Text("Login").tag(true)
                    Text("Create account").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(5)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 64))
                    .padding()
                
                TextField("Email", text: $email).padding()
                SecureField("Password", text: $password).padding()
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Create account")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                        Spacer()
                    }.background(Color.blue)
                }.cornerRadius(4)

                
                
                
                Text("Scroll view content")
            }
            .navigationTitle("Create account")
            .padding(.horizontal, 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
