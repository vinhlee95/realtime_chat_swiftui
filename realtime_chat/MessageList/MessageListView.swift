//
//  MessageListView.swift
//  realtime_chat
//
//  Created by Vinh Le on 1.9.2022.
//

import SwiftUI


struct MessageListView: View {
    @State var shouldShowLogoutActionSheet = false
    
    private var CustomNavBar: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.fill").font(.system(size: 28))
            VStack(alignment: .leading, spacing: 4) {
                Text("User name")
                HStack {
                    Circle().foregroundColor(.green).frame(width: 14, height: 14)
                    Text("online")
                }
            }
            Spacer()
            Button {
                shouldShowLogoutActionSheet.toggle()
            } label: {
                Image(systemName: "gear").font(.system(size: 28))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutActionSheet) {
            .init(title: Text("Settings"), buttons: [
                .destructive(Text("Logout"), action: {
                    print("Logout")
                }),
                .cancel()
            ])
        }
    }
    
    private var NewMessageButton: some View {
        Button(action: {
            print("New message")
        }, label: {
            HStack {
                Spacer()
                Text("+ New Message")
                Spacer()
            }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(48)
                .shadow(radius: 14)
        })
        .padding()
    }
    
    private var MessageLine: some View {
        HStack {
            Image(systemName: "person.fill").font(.system(size: 32))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(Color.black, lineWidth: 1)
                )
            VStack(alignment: .leading) {
                Text("Username")
                Text("Message content")
            }
            Spacer()
            Text("22 days")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CustomNavBar
                ScrollView {
                    ForEach(0..<20, id: \.self) {num in
                        MessageLine
                        Divider()
                    }
                }
                .navigationBarHidden(true)
                .padding(.horizontal)
            }
        }
        .overlay(
            NewMessageButton,
            alignment: .bottom
        )
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
